<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List,java.text.SimpleDateFormat" %>
<html>
<head>
    <title>
        <%
            Object emprestimo = request.getAttribute("emprestimo");
            if (emprestimo != null) {
        %>
            Editar Empréstimo
        <%
            } else {
        %>
            Novo Empréstimo
        <%
            }
        %>
    </title>
    <link rel="stylesheet" href="styles/emprestimosForms.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>

<div class="container">

    <%
        String mensagem = (String) session.getAttribute("mensagem");
        if (mensagem != null) {
    %>
        <div class="flash-message success"><%= mensagem %></div>
    <%
            session.removeAttribute("mensagem");
        }
    %>

    <h2 class="title">
        <%
            if (emprestimo != null) {
        %>
            Editar Empréstimo
        <%
            } else {
        %>
            Novo Empréstimo
        <%
            }
        %>
    </h2>

    <%
        String acao = (emprestimo != null) ? "atualizar" : "inserir";

        String idEmprestimo = "";
        Integer usuarioIdSelecionado = null;
        Integer livroIdSelecionado = null;
        java.util.Date dataEmprestimo = null;
        java.util.Date dataDevolucaoPrevista = null;
        String status = "";

        if (emprestimo != null) {
            Class<?> cls = emprestimo.getClass();

            idEmprestimo = String.valueOf(cls.getMethod("getId").invoke(emprestimo));
            usuarioIdSelecionado = (Integer) cls.getMethod("getIdUsuario").invoke(emprestimo);
            livroIdSelecionado = (Integer) cls.getMethod("getIdLivro").invoke(emprestimo);
            dataEmprestimo = (java.util.Date) cls.getMethod("getDataEmprestimo").invoke(emprestimo);
            dataDevolucaoPrevista = (java.util.Date) cls.getMethod("getDataDevolucaoPrevista").invoke(emprestimo);
            Object statusEnum = cls.getMethod("getStatus").invoke(emprestimo);
            status = (statusEnum != null) ? statusEnum.toString() : "";

        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        List<?> listaUsuarios = (List<?>) request.getAttribute("listaUsuarios");
        List<?> listaLivros = (List<?>) request.getAttribute("listaLivros");
    %>

    <form action="emprestimo" method="post" class="form-emprestimo">
        <input type="hidden" name="acao" value="<%= acao %>"/>
        <% if (emprestimo != null) { %>
            <input type="hidden" name="id" value="<%= idEmprestimo %>"/>
        <% } %>

        <label for="id_usuario">Usuário:</label>
        <select id="id_usuario" name="id_usuario" required>
            <option value="">--Selecione--</option>
            <%
                if (listaUsuarios != null) {
                    for (Object usuario : listaUsuarios) {
                        Class<?> c = usuario.getClass();
                        String id = String.valueOf(c.getMethod("getId").invoke(usuario));
                        String nome = (String) c.getMethod("getNome").invoke(usuario);
                        String selected = id.equals(String.valueOf(usuarioIdSelecionado)) ? "selected" : "";
            %>
                <option value="<%= id %>" <%= selected %>><%= nome %></option>
            <%
                    }
                }
            %>
        </select>

        <label for="id_livro">Livro:</label>
        <select id="id_livro" name="id_livro" required>
            <option value="">--Selecione--</option>
            <%
                if (listaLivros != null) {
                    for (Object livro : listaLivros) {
                        Class<?> c = livro.getClass();
                        String id = String.valueOf(c.getMethod("getId").invoke(livro));
                        String titulo = (String) c.getMethod("getTitulo").invoke(livro);
                        String selected = id.equals(String.valueOf(livroIdSelecionado)) ? "selected" : "";
            %>
                <option value="<%= id %>" <%= selected %>><%= titulo %></option>
            <%
                    }
                }
            %>
        </select>

        <label for="data_emprestimo">Data Empréstimo:</label>
        <input type="date" id="data_emprestimo" name="data_emprestimo" value="<%= (dataEmprestimo != null) ? sdf.format(dataEmprestimo) : "" %>" required/>

        <label for="data_devolucao_prevista">Data Devolução Prevista:</label>
        <input type="date" id="data_devolucao_prevista" name="data_devolucao_prevista" value="<%= (dataDevolucaoPrevista != null) ? sdf.format(dataDevolucaoPrevista) : "" %>" required/>

        <input type="hidden" name="status" value="ATIVO" />

        <div class="form-buttons">
           <button type="submit" class="btn-primary">
               <i class="fas fa-save"></i> Salvar
           </button>
           <a href="emprestimo?acao=listar" class="btn-secondary">
               <i class="fas fa-times-circle"></i> Cancelar
           </a>
       </div>
        
    </form>
</div>

</body>
</html>
