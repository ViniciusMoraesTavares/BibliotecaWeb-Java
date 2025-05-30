<%@ page contentType="text/html;charset=UTF-8" language="java"
    import="java.util.List,java.util.ArrayList,java.util.Date,java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Lista de Empréstimos</title>
    <link rel="stylesheet" href="styles/emprestimos.css" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script>
      function showTab(tab) {
        ['ativos','devolvidos','todos'].forEach(t => {
          document.getElementById(t).style.display = (t===tab)?'block':'none';
          document.getElementById(t+'-btn')
                  .classList.toggle('active', t===tab);
        });
      }
      window.onload = () => showTab('ativos');
    </script>
</head>
<body>
  <div class="card">
    <% String msg = (String) session.getAttribute("mensagem");
       if (msg!=null && !msg.isEmpty()) { %>
      <div class="mensagem-sucesso">
        <i class="fa fa-check-circle"></i> <%= msg %>
      </div>
    <% session.removeAttribute("mensagem"); } %>

    <h2 class="page-title"><i class="fa fa-book-reader"></i> Empréstimos</h2>
    <div class="actions">
      <a href="emprestimo?acao=novo" class="btn-primary">
        <i class="fa fa-plus"></i> Novo Empréstimo
      </a>
      <a href="emprestimos/emprestimos-relatorio.jsp" class="btn-secondary">
        <i class="fa fa-file-alt"></i> Relatório
      </a>
      <a href="index.jsp" class="btn-secondary">
        <i class="fa fa-arrow-left"></i> Voltar
      </a>
    </div>

    <div class="tabs">
      <button id="ativos-btn" class="tab-button" onclick="showTab('ativos')">
        Ativos / Atrasados
      </button>
      <button id="devolvidos-btn" class="tab-button" onclick="showTab('devolvidos')">
        Devolvidos
      </button>
      <button id="todos-btn" class="tab-button" onclick="showTab('todos')">
        Todos
      </button>
    </div>

    <%
      List<?> listaEmprestimos = (List<?>) request.getAttribute("listaEmprestimos");
      List<?> listaUsuarios    = (List<?>) request.getAttribute("listaUsuarios");
      List<?> listaLivros      = (List<?>) request.getAttribute("listaLivros");
      SimpleDateFormat sdf     = new SimpleDateFormat("dd/MM/yyyy");
      Date hoje                = new Date();

      List<Object> ativos   = new ArrayList<>(),
                   devolvidos = new ArrayList<>(),
                   todos      = new ArrayList<>();
      if (listaEmprestimos!=null) {
        for (Object e: listaEmprestimos) {
          Class<?> c = e.getClass();
          Date real = (Date) c.getMethod("getDataDevolucaoReal").invoke(e);
          if (real==null) ativos.add(e);
          else devolvidos.add(e);
          todos.add(e);
        }
      }
    %>

    <!-- ABA ATIVOS / ATRASADOS -->
    <div id="ativos" class="tab-content" style="display:none;">
      <% if (ativos.isEmpty()) { %>
        <p class="no-data">Nenhum empréstimo ativo ou atrasado.</p>
      <% } else {
           for (Object u : listaUsuarios) {
             Class<?> cu = u.getClass();
             Integer uid = (Integer) cu.getMethod("getId").invoke(u);
             String nome = (String) cu.getMethod("getNome").invoke(u);

             List<Object> meus = new ArrayList<>();
             for (Object e: ativos) {
               Class<?> ce = e.getClass();
               if (uid.equals(ce.getMethod("getIdUsuario").invoke(e)))
                 meus.add(e);
             }
             if (meus.isEmpty()) continue;
      %>
      <div class="user-block">
        <h3>Usuário: <%= nome %></h3>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Emprest.</th>
                <th>Prevista</th>
                <th>Status</th>
                <th class="actions-header">Ações</th>
              </tr>
            </thead>
            <tbody>
            <% for (Object e: meus) {
                 Class<?> ce = e.getClass();
                 String idE = String.valueOf(ce.getMethod("getId").invoke(e));
                 Integer lid = (Integer) ce.getMethod("getIdLivro").invoke(e);
                 String tit=""; 
                 for (Object l: listaLivros) {
                   Class<?> cl = l.getClass();
                   if (lid.equals(cl.getMethod("getId").invoke(l))) {
                     tit = (String) cl.getMethod("getTitulo").invoke(l);
                     break;
                   }
                 }
                 Date d0   = (Date) ce.getMethod("getDataEmprestimo").invoke(e);
                 Date d1   = (Date) ce.getMethod("getDataDevolucaoPrevista").invoke(e);
                 Date real = (Date) ce.getMethod("getDataDevolucaoReal").invoke(e);

                 String sts = real!=null
                              ? "Devolvido"
                              : (d1!=null && hoje.after(d1) ? "Atrasado" : "Ativo");
            %>
              <tr>
                <td><%= idE %></td>
                <td><%= tit %></td>
                <td><%= d0!=null?sdf.format(d0):"" %></td>
                <td><%= d1!=null?sdf.format(d1):"" %></td>
                <td><%= sts %></td>
                <td class="actions-cell">
                  <a href="emprestimo?acao=editar&id=<%= idE %>"
                     class="btn-edit" title="Editar">
                    <i class="fa fa-edit"></i>
                  </a>
                  <% if (real!=null) { %>
                    <button class="btn-disabled" disabled title="Já devolvido">
                      <i class="fa fa-check-double"></i>
                    </button>
                  <% } else { %>
                    <a href="emprestimo?acao=devolver&id=<%= idE %>"
                       onclick="return confirm('Confirma a devolução?')"
                       class="btn-primary" title="Confirmar Devolução">
                      <i class="fa fa-check"></i>
                    </a>
                  <% } %>
                  <a href="emprestimo?acao=deletar&id=<%= idE %>"
                     onclick="return confirm('Confirma exclusão?')"
                     class="btn-delete" title="Excluir">
                    <i class="fa fa-trash"></i>
                  </a>
                </td>
              </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <% } } %>
    </div>

    <!-- ABA DEVOLVIDOS -->
    <div id="devolvidos" class="tab-content" style="display:none;">
      <% if (devolvidos.isEmpty()) { %>
        <p class="no-data">Nenhum empréstimo devolvido.</p>
      <% } else {
           for (Object u : listaUsuarios) {
             Class<?> cu = u.getClass();
             Integer uid = (Integer) cu.getMethod("getId").invoke(u);
             String nome = (String) cu.getMethod("getNome").invoke(u);

             List<Object> meus = new ArrayList<>();
             for (Object e: devolvidos) {
               Class<?> ce = e.getClass();
               if (uid.equals(ce.getMethod("getIdUsuario").invoke(e)))
                 meus.add(e);
             }
             if (meus.isEmpty()) continue;
      %>
      <div class="user-block">
        <h3>Usuário: <%= nome %></h3>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Emprest.</th>
                <th>Prevista</th>
                <th>Real</th>
                <th>Status</th>
                <th class="actions-header">Ações</th>
              </tr>
            </thead>
            <tbody>
            <% for (Object e: meus) {
                 Class<?> ce = e.getClass();
                 String idE = String.valueOf(ce.getMethod("getId").invoke(e));
                 Integer lid = (Integer) ce.getMethod("getIdLivro").invoke(e);
                 String tit=""; 
                 for (Object l: listaLivros) {
                   Class<?> cl = l.getClass();
                   if (lid.equals(cl.getMethod("getId").invoke(l))) {
                     tit = (String) cl.getMethod("getTitulo").invoke(l);
                     break;
                   }
                 }
                 Date d0 = (Date) ce.getMethod("getDataEmprestimo").invoke(e);
                 Date d1 = (Date) ce.getMethod("getDataDevolucaoPrevista").invoke(e);
                 Date d2 = (Date) ce.getMethod("getDataDevolucaoReal").invoke(e);
            %>
              <tr>
                <td><%= idE %></td>
                <td><%= tit %></td>
                <td><%= d0!=null?sdf.format(d0):"" %></td>
                <td><%= d1!=null?sdf.format(d1):"" %></td>
                <td><%= d2!=null?sdf.format(d2):"" %></td>
                <td>Devolvido</td>
                <td class="actions-cell">
                  <button class="btn-disabled" disabled title="Já devolvido">
                    <i class="fa fa-check-double"></i>
                  </button>
                  <a href="emprestimo?acao=editar&id=<%= idE %>"
                     class="btn-edit" title="Editar">
                    <i class="fa fa-edit"></i>
                  </a>
                  <a href="emprestimo?acao=deletar&id=<%= idE %>"
                     onclick="return confirm('Confirma exclusão?')"
                     class="btn-delete" title="Excluir">
                    <i class="fa fa-trash"></i>
                  </a>
                </td>
              </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <% } } %>
    </div>

    <!-- ABA TODOS -->
    <div id="todos" class="tab-content" style="display:none;">
      <% if (todos.isEmpty()) { %>
        <p class="no-data">Nenhum empréstimo cadastrado.</p>
      <% } else {
           for (Object u : listaUsuarios) {
             Class<?> cu = u.getClass();
             Integer uid = (Integer) cu.getMethod("getId").invoke(u);
             String nome = (String) cu.getMethod("getNome").invoke(u);

             List<Object> meus = new ArrayList<>();
             for (Object e: todos) {
               Class<?> ce = e.getClass();
               if (uid.equals(ce.getMethod("getIdUsuario").invoke(e)))
                 meus.add(e);
             }
             if (meus.isEmpty()) continue;
      %>
      <div class="user-block">
        <h3>Usuário: <%= nome %></h3>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Emprest.</th>
                <th>Prevista</th>
                <th>Real</th>
                <th>Status</th>
                <th class="actions-header">Ações</th>
              </tr>
            </thead>
            <tbody>
            <% for (Object e: meus) {
                 Class<?> ce = e.getClass();
                 String idE = String.valueOf(ce.getMethod("getId").invoke(e));
                 Integer lid = (Integer) ce.getMethod("getIdLivro").invoke(e);
                 String tit=""; 
                 for (Object l: listaLivros) {
                   Class<?> cl = l.getClass();
                   if (lid.equals(cl.getMethod("getId").invoke(l))) {
                     tit = (String) cl.getMethod("getTitulo").invoke(l);
                     break;
                   }
                 }
                 Date d0 = (Date) ce.getMethod("getDataEmprestimo").invoke(e);
                 Date d1 = (Date) ce.getMethod("getDataDevolucaoPrevista").invoke(e);
                 Date d2 = (Date) ce.getMethod("getDataDevolucaoReal").invoke(e);

                 String sts = d2!=null
                              ? "Devolvido"
                              : (d1!=null && hoje.after(d1) ? "Atrasado" : "Ativo");
            %>
              <tr>
                <td><%= idE %></td>
                <td><%= tit %></td>
                <td><%= d0!=null?sdf.format(d0):"" %></td>
                <td><%= d1!=null?sdf.format(d1):"" %></td>
                <td><%= d2!=null?sdf.format(d2):"" %></td>
                <td><%= sts %></td>
                <td class="actions-cell">
                  <a href="emprestimo?acao=editar&id=<%= idE %>"
                     class="btn-edit" title="Editar">
                    <i class="fa fa-edit"></i>
                  </a>
                  <% if (d2!=null) { %>
                    <button class="btn-disabled" disabled title="Já devolvido">
                      <i class="fa fa-check-double"></i>
                    </button>
                  <% } else { %>
                    <a href="emprestimo?acao=devolver&id=<%= idE %>"
                       onclick="return confirm('Confirma a devolução?')"
                       class="btn-primary" title="Confirmar Devolução">
                      <i class="fa fa-check"></i>
                    </a>
                  <% } %>
                  <a href="emprestimo?acao=deletar&id=<%= idE %>"
                     onclick="return confirm('Confirma exclusão?')"
                     class="btn-delete" title="Excluir">
                    <i class="fa fa-trash"></i>
                  </a>
                </td>
              </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <% } } %>
    </div>

  </div>
</body>
</html>
