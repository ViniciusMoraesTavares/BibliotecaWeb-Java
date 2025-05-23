<%@ page import="java.util.List" %>
<%@ page import="modelo.Emprestimo" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Relatório de Empréstimos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/relatorioEmprestimos.css" />
</head>
<body>
    <div class="card">
        <div class="page-title">
            <i class="fas fa-file-alt"></i>
            <span>Relatório de Empréstimos por Período</span>
        </div>

        <form action="<%= request.getContextPath() %>/emprestimo" method="get">
            <input type="hidden" name="acao" value="relatorio" />
            <label for="dataInicio">Data Início:</label>
            <input type="date" id="dataInicio" name="dataInicio" required
                value="<%= request.getAttribute("dataInicio") != null ? request.getAttribute("dataInicio") : "" %>" />

            <label for="dataFim">Data Fim:</label>
            <input type="date" id="dataFim" name="dataFim" required
                value="<%= request.getAttribute("dataFim") != null ? request.getAttribute("dataFim") : "" %>" />

            <button type="submit">Gerar Relatório</button>
        </form>

        <%
            List<Emprestimo> lista = (List<Emprestimo>) request.getAttribute("listaEmprestimos");
            String dataInicio = (String) request.getAttribute("dataInicio");
            String dataFim = (String) request.getAttribute("dataFim");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            if (lista != null) {
        %>
            <h2>Relatório de Empréstimos</h2>
            <p>Período: <%= dataInicio != null ? dataInicio.replaceAll("(\\d{4})-(\\d{2})-(\\d{2})", "$3/$2/$1") : "" %> até <%= dataFim != null ? dataFim.replaceAll("(\\d{4})-(\\d{2})-(\\d{2})", "$3/$2/$1") : "" %></p>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Data Empréstimo</th>
                        <th>Usuário</th>
                        <th>Livro</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (!lista.isEmpty()) {
                        for (Emprestimo e : lista) {
                %>
                    <tr>
                        <td><%= e.getId() %></td>
                        <td><%= e.getDataEmprestimo() != null ? sdf.format(e.getDataEmprestimo()) : "" %></td>
                        <td><%= e.getUsuario().getNome() %></td>
                        <td><%= e.getLivro().getTitulo() %></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr><td colspan="4" style="text-align:center;">Nenhum empréstimo encontrado no período.</td></tr>
                <%
                    }
                %>
                </tbody>
            </table>
        <%
            }
        %>
        
        <form action="<%= request.getContextPath() %>/emprestimo" method="get" style="margin-top: 20px;">
          <input type="hidden" name="acao" value="listar" />
          <button type="submit" class="btn-secondary">Voltar</button>
        </form>

    </div>

    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>
