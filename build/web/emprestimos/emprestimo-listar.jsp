<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List,java.util.ArrayList,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Lista de Empréstimos</title>
    <link rel="stylesheet" href="styles/emprestimos.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script>
      function showTab(tab) {
        const tabs = ['ativos', 'devolvidos', 'todos'];
        tabs.forEach(t => {
          document.getElementById(t).style.display = (t === tab) ? 'block' : 'none';
          document.getElementById(t + '-btn').classList.toggle('active', t === tab);
        });
      }
      window.onload = function() {
        showTab('ativos'); // Abre a tab "Ativos" por padrão
      }
    </script>
</head>
<body>
  <div class="card">
    <%
        String mensagem = (String) session.getAttribute("mensagem");
        if (mensagem != null && !mensagem.isEmpty()) {
    %>
        <div class="mensagem-sucesso"><i class="fa fa-check-circle"></i> <%= mensagem %></div>
    <%
            session.removeAttribute("mensagem");
        }
    %>

    <h2 class="page-title"><i class="fa fa-book-reader"></i> Empréstimos</h2>

    <div class="actions">
      <a href="emprestimo?acao=novo" class="btn-primary"><i class="fa fa-plus"></i> Novo Empréstimo</a>
      <a href="emprestimos/emprestimos-relatorio.jsp" class="btn-secondary"><i class="fa fa-file-alt"></i> Relatório</a>
      <a href="index.jsp" class="btn-secondary"><i class="fa fa-arrow-left"></i> Voltar</a>
    </div>

    <div class="tabs">
      <button id="ativos-btn" class="tab-button" onclick="showTab('ativos')">Ativos / Atrasados</button>
      <button id="devolvidos-btn" class="tab-button" onclick="showTab('devolvidos')">Devolvidos</button>
      <button id="todos-btn" class="tab-button" onclick="showTab('todos')">Todos</button>
    </div>

    <%
        List<?> listaEmprestimos = (List<?>) request.getAttribute("listaEmprestimos");
        List<?> listaUsuarios = (List<?>) request.getAttribute("listaUsuarios");
        List<?> listaLivros = (List<?>) request.getAttribute("listaLivros");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Date hoje = new Date();

        List<Object> emprestimosAtivos = new ArrayList<>();
        List<Object> emprestimosDevolvidos = new ArrayList<>();
        List<Object> emprestimosTodos = new ArrayList<>();

        if (listaEmprestimos != null) {
            for (Object emp : listaEmprestimos) {
                Class<?> cls = emp.getClass();
                Date dataDevolucaoReal = (Date) cls.getMethod("getDataDevolucaoReal").invoke(emp);
                if (dataDevolucaoReal == null) {
                    emprestimosAtivos.add(emp);
                } else {
                    emprestimosDevolvidos.add(emp);
                }
                emprestimosTodos.add(emp);
            }
        }
    %>

    <!-- TAB ATIVOS / ATRASADOS -->
    <div id="ativos" class="tab-content" style="display:none;">
      <%
        if (emprestimosAtivos.isEmpty()) {
      %>
        <p class="no-data">Nenhum empréstimo ativo ou atrasado.</p>
      <%
        } else {
          for (Object usuario : listaUsuarios) {
              Class<?> clsUsu = usuario.getClass();
              Integer usuarioId = (Integer) clsUsu.getMethod("getId").invoke(usuario);
              String nomeUsuario = (String) clsUsu.getMethod("getNome").invoke(usuario);

              List<Object> emprestimosDoUsuario = new ArrayList<>();
              for (Object emp : emprestimosAtivos) {
                  Class<?> clsEmp = emp.getClass();
                  Integer idUsuarioEmp = (Integer) clsEmp.getMethod("getIdUsuario").invoke(emp);
                  if (idUsuarioEmp.equals(usuarioId)) {
                      emprestimosDoUsuario.add(emp);
                  }
              }

              if (!emprestimosDoUsuario.isEmpty()) {
      %>
      <div class="user-block">
        <h3>Usuário: <%= nomeUsuario %></h3>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Data Empréstimo</th>
                <th>Data Devolução Prevista</th>
                <th>Status</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
            <%
              for (Object emprestimo : emprestimosDoUsuario) {
                  Class<?> cls = emprestimo.getClass();

                  String idEmprestimo = String.valueOf(cls.getMethod("getId").invoke(emprestimo));

                  Integer idLivro = (Integer) cls.getMethod("getIdLivro").invoke(emprestimo);
                  String tituloLivro = "";
                  if (listaLivros != null) {
                      for (Object livro : listaLivros) {
                          Class<?> clsLivro = livro.getClass();
                          Integer livroId = (Integer) clsLivro.getMethod("getId").invoke(livro);
                          if (livroId.equals(idLivro)) {
                              tituloLivro = (String) clsLivro.getMethod("getTitulo").invoke(livro);
                              break;
                          }
                      }
                  }

                  Date dataEmprestimo = (Date) cls.getMethod("getDataEmprestimo").invoke(emprestimo);
                  Date dataDevolucaoPrevista = (Date) cls.getMethod("getDataDevolucaoPrevista").invoke(emprestimo);

                  Date dataDevolucaoReal = (Date) cls.getMethod("getDataDevolucaoReal").invoke(emprestimo);

                  String status = "";
                  if (dataDevolucaoReal != null) {
                      status = "Devolvido";
                  } else {
                      if (dataDevolucaoPrevista != null && hoje.after(dataDevolucaoPrevista)) {
                          status = "Atrasado";
                      } else {
                          status = "Ativo";
                      }
                  }
            %>
              <tr>
                  <td><%= idEmprestimo %></td>
                  <td><%= tituloLivro %></td>
                  <td><%= (dataEmprestimo != null) ? sdf.format(dataEmprestimo) : "" %></td>
                  <td><%= (dataDevolucaoPrevista != null) ? sdf.format(dataDevolucaoPrevista) : "" %></td>
                  <td><%= status %></td>
                  <td class="actions-cell">
                      <a href="emprestimo?acao=editar&id=<%= idEmprestimo %>" class="btn-edit" title="Editar"><i class="fa fa-edit"></i></a>
                      <a href="emprestimo?acao=confirmarDevolucao&id=<%= idEmprestimo %>" class="btn-primary" title="Confirmar Devolução"><i class="fa fa-check"></i></a>
                      <a href="emprestimo?acao=deletar&id=<%= idEmprestimo %>" onclick="return confirm('Confirma exclusão?')" class="btn-delete" title="Excluir"><i class="fa fa-trash"></i></a>
                  </td>
              </tr>
            <%
              }
            %>
            </tbody>
          </table>
        </div>
      </div>
      <%
              }
          }
        }
      %>
    </div>

    <!-- TAB DEVOLVIDOS -->
    <div id="devolvidos" class="tab-content" style="display:none;">
      <%
        if (emprestimosDevolvidos.isEmpty()) {
      %>
        <p class="no-data">Nenhum empréstimo devolvido.</p>
      <%
        } else {
          for (Object usuario : listaUsuarios) {
              Class<?> clsUsu = usuario.getClass();
              Integer usuarioId = (Integer) clsUsu.getMethod("getId").invoke(usuario);
              String nomeUsuario = (String) clsUsu.getMethod("getNome").invoke(usuario);

              List<Object> emprestimosDoUsuario = new ArrayList<>();
              for (Object emp : emprestimosDevolvidos) {
                  Class<?> clsEmp = emp.getClass();
                  Integer idUsuarioEmp = (Integer) clsEmp.getMethod("getIdUsuario").invoke(emp);
                  if (idUsuarioEmp.equals(usuarioId)) {
                      emprestimosDoUsuario.add(emp);
                  }
              }

              if (!emprestimosDoUsuario.isEmpty()) {
      %>
      <div class="user-block">
        <h3>Usuário: <%= nomeUsuario %></h3>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Data Empréstimo</th>
                <th>Data Devolução Prevista</th>
                <th>Data Devolução Real</th>
                <th>Status</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
            <%
              for (Object emprestimo : emprestimosDoUsuario) {
                  Class<?> cls = emprestimo.getClass();

                  String idEmprestimo = String.valueOf(cls.getMethod("getId").invoke(emprestimo));

                  Integer idLivro = (Integer) cls.getMethod("getIdLivro").invoke(emprestimo);
                  String tituloLivro = "";
                  if (listaLivros != null) {
                      for (Object livro : listaLivros) {
                          Class<?> clsLivro = livro.getClass();
                          Integer livroId = (Integer) clsLivro.getMethod("getId").invoke(livro);
                          if (livroId.equals(idLivro)) {
                              tituloLivro = (String) clsLivro.getMethod("getTitulo").invoke(livro);
                              break;
                          }
                      }
                  }

                  Date dataEmprestimo = (Date) cls.getMethod("getDataEmprestimo").invoke(emprestimo);
                  Date dataDevolucaoPrevista = (Date) cls.getMethod("getDataDevolucaoPrevista").invoke(emprestimo);
                  Date dataDevolucaoReal = (Date) cls.getMethod("getDataDevolucaoReal").invoke(emprestimo);

                  String status = "Devolvido";

            %>
              <tr>
                  <td><%= idEmprestimo %></td>
                  <td><%= tituloLivro %></td>
                  <td><%= (dataEmprestimo != null) ? sdf.format(dataEmprestimo) : "" %></td>
                  <td><%= (dataDevolucaoPrevista != null) ? sdf.format(dataDevolucaoPrevista) : "" %></td>
                  <td><%= (dataDevolucaoReal != null) ? sdf.format(dataDevolucaoReal) : "" %></td>
                  <td><%= status %></td>
                  <td class="actions-cell">
                      <a href="emprestimo?acao=editar&id=<%= idEmprestimo %>" class="btn-edit" title="Editar"><i class="fa fa-edit"></i></a>
                      <a href="emprestimo?acao=confirmarDevolucao&id=<%= idEmprestimo %>" class="btn-primary" title="Atualizar Devolução"><i class="fa fa-check"></i></a>
                      <a href="emprestimo?acao=deletar&id=<%= idEmprestimo %>" onclick="return confirm('Confirma exclusão?')" class="btn-delete" title="Excluir"><i class="fa fa-trash"></i></a>
                  </td>
              </tr>
            <%
              }
            %>
            </tbody>
          </table>
        </div>
      </div>
      <%
              }
          }
        }
      %>
    </div>

    <!-- TAB TODOS -->
    <div id="todos" class="tab-content" style="display:none;">
      <%
        if (emprestimosTodos.isEmpty()) {
      %>
        <p class="no-data">Nenhum empréstimo cadastrado.</p>
      <%
        } else {
          for (Object usuario : listaUsuarios) {
              Class<?> clsUsu = usuario.getClass();
              Integer usuarioId = (Integer) clsUsu.getMethod("getId").invoke(usuario);
              String nomeUsuario = (String) clsUsu.getMethod("getNome").invoke(usuario);

              List<Object> emprestimosDoUsuario = new ArrayList<>();
              for (Object emp : emprestimosTodos) {
                  Class<?> clsEmp = emp.getClass();
                  Integer idUsuarioEmp = (Integer) clsEmp.getMethod("getIdUsuario").invoke(emp);
                  if (idUsuarioEmp.equals(usuarioId)) {
                      emprestimosDoUsuario.add(emp);
                  }
              }

              if (!emprestimosDoUsuario.isEmpty()) {
      %>
      <div class="user-block">
        <h3>Usuário: <%= nomeUsuario %></h3>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Data Empréstimo</th>
                <th>Data Devolução Prevista</th>
                <th>Data Devolução Real</th>
                <th>Status</th>
                <th>Ações</th>
              </tr>
            </thead>
            <tbody>
            <%
              for (Object emprestimo : emprestimosDoUsuario) {
                  Class<?> cls = emprestimo.getClass();

                  String idEmprestimo = String.valueOf(cls.getMethod("getId").invoke(emprestimo));

                  Integer idLivro = (Integer) cls.getMethod("getIdLivro").invoke(emprestimo);
                  String tituloLivro = "";
                  if (listaLivros != null) {
                      for (Object livro : listaLivros) {
                          Class<?> clsLivro = livro.getClass();
                          Integer livroId = (Integer) clsLivro.getMethod("getId").invoke(livro);
                          if (livroId.equals(idLivro)) {
                              tituloLivro = (String) clsLivro.getMethod("getTitulo").invoke(livro);
                              break;
                          }
                      }
                  }

                  Date dataEmprestimo = (Date) cls.getMethod("getDataEmprestimo").invoke(emprestimo);
                  Date dataDevolucaoPrevista = (Date) cls.getMethod("getDataDevolucaoPrevista").invoke(emprestimo);
                  Date dataDevolucaoReal = (Date) cls.getMethod("getDataDevolucaoReal").invoke(emprestimo);

                  String status = "";
                  if (dataDevolucaoReal != null) {
                      status = "Devolvido";
                  } else if (dataDevolucaoPrevista != null && hoje.after(dataDevolucaoPrevista)) {
                      status = "Atrasado";
                  } else {
                      status = "Ativo";
                  }
            %>
              <tr>
                  <td><%= idEmprestimo %></td>
                  <td><%= tituloLivro %></td>
                  <td><%= (dataEmprestimo != null) ? sdf.format(dataEmprestimo) : "" %></td>
                  <td><%= (dataDevolucaoPrevista != null) ? sdf.format(dataDevolucaoPrevista) : "" %></td>
                  <td><%= (dataDevolucaoReal != null) ? sdf.format(dataDevolucaoReal) : "" %></td>
                  <td><%= status %></td>
                  <td class="actions-cell">
                      <a href="emprestimo?acao=editar&id=<%= idEmprestimo %>" class="btn-edit" title="Editar"><i class="fa fa-edit"></i></a>
                      <a href="emprestimo?acao=confirmarDevolucao&id=<%= idEmprestimo %>" class="btn-primary" title="Confirmar / Atualizar Devolução"><i class="fa fa-check"></i></a>
                      <a href="emprestimo?acao=deletar&id=<%= idEmprestimo %>" onclick="return confirm('Confirma exclusão?')" class="btn-delete" title="Excluir"><i class="fa fa-trash"></i></a>
                  </td>
              </tr>
            <%
              }
            %>
            </tbody>
          </table>
        </div>
      </div>
      <%
              }
          }
        }
      %>
    </div>

  </div>
</body>
</html>
