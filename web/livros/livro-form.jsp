<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>
        <%
            Object livroObj = request.getAttribute("livro");
            out.print(livroObj != null ? "Editar Livro" : "Novo Livro");
        %>
    </title>
    <link rel="stylesheet" href="styles/livros.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
<div class="card">
    <% String mensagem = (String) session.getAttribute("mensagem"); %>
    <% if (mensagem != null && !mensagem.isEmpty()) { %>
        <div class="mensagem-sucesso"><i class="fa fa-check-circle"></i> <%= mensagem %></div>
        <% session.removeAttribute("mensagem"); %>
    <% } %>

    <h2 class="page-title"><%= (request.getAttribute("livro") != null ? "Editar Livro" : "Novo Livro") %></h2>

    <%
        Object livro = request.getAttribute("livro");
        boolean isEdicao = (livro != null);

        String id = "";
        String titulo = "";
        String autor = "";
        String editora = "";
        String isbn = "";
        int anoPublicacao = java.time.LocalDate.now().getYear();
        int quantidadeDisponivel = 1;
        String categoria = "";
        String descricao = "";
        int quantidadeEmprestada = 0; // <-- Adicionado

        if (isEdicao) {
            try {
                java.lang.reflect.Method m;

                m = livro.getClass().getMethod("getId");
                Object idObj = m.invoke(livro);
                if (idObj != null) id = idObj.toString();

                m = livro.getClass().getMethod("getTitulo");
                Object t = m.invoke(livro); if (t != null) titulo = t.toString();

                m = livro.getClass().getMethod("getAutor");
                Object a = m.invoke(livro); if (a != null) autor = a.toString();

                m = livro.getClass().getMethod("getEditora");
                Object e = m.invoke(livro); if (e != null) editora = e.toString();

                m = livro.getClass().getMethod("getIsbn");
                Object i = m.invoke(livro); if (i != null) isbn = i.toString();

                m = livro.getClass().getMethod("getAnoPublicacao");
                Object ano = m.invoke(livro);
                if (ano != null) anoPublicacao = Integer.parseInt(ano.toString());

                m = livro.getClass().getMethod("getQuantidadeDisponivel");
                Object qtd = m.invoke(livro);
                if (qtd != null) quantidadeDisponivel = Integer.parseInt(qtd.toString());

                m = livro.getClass().getMethod("getQuantidadeEmprestada"); // <-- Aqui
                Object qtdEmp = m.invoke(livro);
                if (qtdEmp != null) quantidadeEmprestada = Integer.parseInt(qtdEmp.toString());

                m = livro.getClass().getMethod("getCategoria");
                Object c = m.invoke(livro); if (c != null) categoria = c.toString();

                m = livro.getClass().getMethod("getDescricao");
                Object d = m.invoke(livro); if (d != null) descricao = d.toString();

            } catch (Exception ignored) {}
        }
    %>

    <form action="livro" method="post" class="formulario">
        <input type="hidden" name="acao" value="<%= isEdicao ? "atualizar" : "inserir" %>" />
        <% if (isEdicao) { %>
            <input type="hidden" name="id" value="<%= id %>" />
        <% } %>

        <label for="titulo">Título:</label>
        <input id="titulo" type="text" name="titulo" value="<%= titulo %>" required />

        <label for="autor">Autor:</label>
        <input id="autor" type="text" name="autor" value="<%= autor %>" required />

        <label for="editora">Editora:</label>
        <input id="editora" type="text" name="editora" value="<%= editora %>" required />

        <label for="ano_publicacao">Ano de Publicação:</label>
        <input id="ano_publicacao" type="number" name="anoPublicacao" min="1000" max="9999" value="<%= anoPublicacao %>" required />

        <label for="isbn">ISBN:</label>
        <input id="isbn" type="text" name="isbn" maxlength="20" value="<%= isbn %>" required />

        <label for="quantidade_disponivel">Quantidade Total:</label>
        <input id="quantidade_disponivel" type="number" 
               name="quantidadeDisponivel" 
               min="<%= quantidadeEmprestada %>" 
               value="<%= quantidadeDisponivel %>" 
               required />
        <% if (quantidadeEmprestada > 0) { %>
            <div class="info-emprestados">
                ⚠ Este livro possui <strong><%= quantidadeEmprestada %></strong> emprestado(s). 
                A quantidade total não pode ser menor que isso.
            </div>
        <% } %>

        <label for="categoria">Categoria:</label>
        <input id="categoria" type="text" name="categoria" value="<%= categoria %>" required />

        <label for="descricao">Descrição:</label>
        <textarea id="descricao" name="descricao" rows="4"><%= descricao %></textarea>

        <div class="form-actions">
            <button type="submit" class="btn-primary"><i class="fa fa-save"></i> Salvar</button>
            <a href="livro?acao=listar" class="btn-secondary"><i class="fa fa-times"></i> Cancelar</a>
        </div>
    </form>
</div>
</body>
</html>