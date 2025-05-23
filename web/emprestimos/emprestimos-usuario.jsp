<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, modelo.Emprestimo, modelo.Usuario, modelo.Livro" %>
<%@ page import="modelo.Emprestimo.StatusEmprestimo" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Empréstimos do Usuário</title>
    <link rel="stylesheet" href="styles/emprestimos-usuario.css">
</head>
<body>

<div class="container">

    <h1>Empréstimos do Usuário</h1>

    <%
        Usuario usuario = (Usuario) request.getAttribute("usuario");
        List<Emprestimo> listaEmprestimos = (List<Emprestimo>) request.getAttribute("listaEmprestimos");
    %>

    <div class="info-usuario">
        <h3>Dados do Usuário:</h3>
        <p><strong>ID:</strong> <%= usuario.getId() %></p>
        <p><strong>Nome:</strong> <%= usuario.getNome() %></p>
        <p><strong>Email:</strong> <%= usuario.getEmail() %></p>
    </div>
    
    <form action="emprestimo" method="get" class="filtros-form">
        <input type="hidden" name="acao" value="listarFiltrado" />
        <input type="hidden" name="id_usuario" value="<%= usuario.getId() %>" />

        <label for="id_livro">Livro:</label>
        <select name="id_livro" id="id_livro">
            <option value="">-- Todos --</option>
            <%
                List<Livro> listaLivros = (List<Livro>) request.getAttribute("listaLivros");
                String filtroIdLivro = (String) request.getAttribute("filtroIdLivro");
                for (Livro l : listaLivros) {
                    String selected = (filtroIdLivro != null && filtroIdLivro.equals(String.valueOf(l.getId()))) ? "selected" : "";
            %>
                <option value="<%= l.getId() %>" <%= selected %>><%= l.getTitulo() %></option>
            <%
                }
            %>
        </select>

        <label for="status">Status:</label>
        <select name="status" id="status">
            <option value="">-- Todos --</option>
            <%
                String filtroStatus = (String) request.getAttribute("filtroStatus");
                for (StatusEmprestimo st : StatusEmprestimo.values()) {
                    String selected = (filtroStatus != null && filtroStatus.equalsIgnoreCase(st.name())) ? "selected" : "";
            %>
                <option value="<%= st.name() %>" <%= selected %>><%= st.name() %></option>
            <%
                }
            %>
        </select>
        
        <div class="campo-com-label">
            <label for="data_inicio">Data Início:</label>
            <input type="date" name="data_inicio" id="data_inicio"
                   value="<%= request.getAttribute("filtroDataInicio") != null ? request.getAttribute("filtroDataInicio") : "" %>">
        </div>

        <div class="campo-com-label">
            <label for="data_fim">Data Fim:</label>
            <input type="date" name="data_fim" id="data_fim"
                   value="<%= request.getAttribute("filtroDataFim") != null ? request.getAttribute("filtroDataFim") : "" %>">
        </div>    
            
        <div class="botoes-filtro">
          <button type="submit" class="btn-primario">Filtrar</button>
          <a href="emprestimo?acao=listarFiltrado&id_usuario=<%= usuario.getId() %>" class="btn-secundario">Limpar</a>
        </div>
    </form>

    <table class="tabela">
        <thead>
            <tr>
                <th>ID</th>
                <th>Livro</th>
                <th>Data Empréstimo</th>
                <th>Data Prevista</th>
                <th>Data Devolução</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (listaEmprestimos != null && !listaEmprestimos.isEmpty()) {
                    for (Emprestimo e : listaEmprestimos) {
            %>
                <tr>
                    <td><%= e.getId() %></td>
                    <td><%= e.getTituloLivro() %></td>
                    <td><%= e.getDataEmprestimoFormatada() %></td>
                    <td><%= e.getDataDevolucaoPrevistaFormatada() %></td>
                    <td><%= e.getDataDevolucaoRealFormatada() != null ? e.getDataDevolucaoRealFormatada() : "-" %></td>
                    <td><%= e.getStatus().name() %></td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="6">Nenhum empréstimo encontrado.</td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <div class="botoes">
        <a href="usuario?acao=listar" class="voltar-btn">Voltar</a>
    </div>

</div>

</body>
</html>
