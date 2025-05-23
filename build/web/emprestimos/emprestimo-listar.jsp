<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List,java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Lista de Empréstimos</title>
    <link rel="stylesheet" href="styles/emprestimos.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Usuário</th>
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
            List<?> listaEmprestimos = (List<?>) request.getAttribute("listaEmprestimos");
            List<?> listaUsuarios = (List<?>) request.getAttribute("listaUsuarios");
            List<?> listaLivros = (List<?>) request.getAttribute("listaLivros");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            if (listaEmprestimos != null && !listaEmprestimos.isEmpty()) {
                for (Object emprestimo : listaEmprestimos) {
                    Class<?> cls = emprestimo.getClass();

                    String idEmprestimo = String.valueOf(cls.getMethod("getId").invoke(emprestimo));

                    Integer idUsuario = (Integer) cls.getMethod("getIdUsuario").invoke(emprestimo);
                    String nomeUsuario = "";
                    if (listaUsuarios != null) {
                        for (Object usuario : listaUsuarios) {
                            Class<?> clsUsu = usuario.getClass();
                            Integer usuarioId = (Integer) clsUsu.getMethod("getId").invoke(usuario);
                            if (usuarioId.equals(idUsuario)) {
                                nomeUsuario = (String) clsUsu.getMethod("getNome").invoke(usuario);
                                break;
                            }
                        }
                    }

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

                    java.util.Date dataEmprestimo = (java.util.Date) cls.getMethod("getDataEmprestimo").invoke(emprestimo);
                    java.util.Date dataDevolucaoPrevista = (java.util.Date) cls.getMethod("getDataDevolucaoPrevista").invoke(emprestimo);
                    java.util.Date dataDevolucaoReal = (java.util.Date) cls.getMethod("getDataDevolucaoReal").invoke(emprestimo);

                    Object statusObj = cls.getMethod("getStatus").invoke(emprestimo);
                    String status = (statusObj != null) ? statusObj.toString() : "";

        %>
            <tr>
                <td><%= idEmprestimo %></td>
                <td><%= nomeUsuario %></td>
                <td><%= tituloLivro %></td>
                <td><%= (dataEmprestimo != null) ? sdf.format(dataEmprestimo) : "" %></td>
                <td><%= (dataDevolucaoPrevista != null) ? sdf.format(dataDevolucaoPrevista) : "" %></td>
                <td><%= (dataDevolucaoReal != null) ? sdf.format(dataDevolucaoReal) : "" %></td>
                <td><%= status %></td>
                <td class="actions-cell">
                    <a href="emprestimo?acao=editar&id=<%= idEmprestimo %>" class="btn-edit" title="Editar"><i class="fa fa-edit"></i></a>
                    <a href="emprestimo?acao=confirmarDevolucao&id=<%= idEmprestimo %>" class="btn-primary" title="Confirmar Devolução"><i class="fa fa-check"></i></a>
                    <a href="emprestimo?acao=deletar&id=<%= idEmprestimo %>" onclick="return confirm('Confirma exclusão?')" class="btn-delete" title="Excluir"><i class="fa fa-trash"></i></a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="8" class="no-data">Nenhum empréstimo encontrado.</td>
            </tr>
        <%
            }
        %>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
