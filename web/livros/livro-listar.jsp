<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List,java.lang.reflect.Method" %>
<html>
<head>
    <title>Lista de Livros</title>
    <link rel="stylesheet" href="styles/livros.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
  <div class="card">
    <h2 class="page-title"><i class="fa fa-book"></i> Lista de Livros</h2>

    <% 
      String mensagem = (String) session.getAttribute("mensagem");
      if (mensagem != null && !mensagem.isEmpty()) { 
    %>
      <div class="mensagem-sucesso"><i class="fa fa-check-circle"></i> <%= mensagem %></div>
    <%
        session.removeAttribute("mensagem");
      }
    %>

    <div class="actions">
      <a href="livro?acao=novo" class="btn-primary"><i class="fa fa-plus"></i> Novo Livro</a>
      <a href="index.jsp" class="btn-secondary"><i class="fa fa-arrow-left"></i> Voltar</a>
    </div>
    
    <div class="search-bar">
        <form action="livro" method="get" style="display: inline-block;">
            <input type="hidden" name="acao" value="buscar">
            <input type="text" name="filtro" placeholder="Buscar por título, autor ou categoria" required>
            <button type="submit" class="btn-search"><i class="fa fa-search"></i> Buscar</button>
        </form>

        <form action="livro" method="get" style="display: inline-block; margin-left: 10px;">
            <input type="hidden" name="acao" value="listar">
            <button type="submit" class="btn-clear"><i class="fa fa-times"></i> Limpar</button>
        </form>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Título</th>
            <th>Autor</th>
            <th>Editora</th>
            <th>Ano</th>
            <th>ISBN</th>
            <th>Disponível</th>
            <th>Categoria</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <%
            List<?> listaLivros = (List<?>) request.getAttribute("listaLivros");
            if (listaLivros != null) {
                for (Object livro : listaLivros) {
                    Method mId = livro.getClass().getMethod("getId");
                    Method mTitulo = livro.getClass().getMethod("getTitulo");
                    Method mAutor = livro.getClass().getMethod("getAutor");
                    Method mEditora = livro.getClass().getMethod("getEditora");
                    Method mAno = livro.getClass().getMethod("getAnoPublicacao");
                    Method mIsbn = livro.getClass().getMethod("getIsbn");
                    Method mQtd = livro.getClass().getMethod("getQuantidadeDisponivel");
                    Method mCategoria = livro.getClass().getMethod("getCategoria");

                    Object id = mId.invoke(livro);
                    Object titulo = mTitulo.invoke(livro);
                    Object autor = mAutor.invoke(livro);
                    Object editora = mEditora.invoke(livro);
                    Object ano = mAno.invoke(livro);
                    Object isbn = mIsbn.invoke(livro);
                    Object quantidade = mQtd.invoke(livro);
                    Object categoria = mCategoria.invoke(livro);
          %>
          <tr>
            <td><%= id != null ? id : "" %></td>
            <td><%= titulo != null ? titulo : "" %></td>
            <td><%= autor != null ? autor : "" %></td>
            <td><%= editora != null ? editora : "" %></td>
            <td><%= ano != null ? ano : "" %></td>
            <td><%= isbn != null ? isbn : "" %></td>
            <td><%= quantidade != null ? quantidade : "" %></td>
            <td><%= categoria != null ? categoria : "" %></td>
            <td class="actions-cell">
              <a href="livro?acao=editar&id=<%= id %>" class="btn-edit" title="Editar"><i class="fa fa-edit"></i></a>
              <a href="livro?acao=deletar&id=<%= id %>" class="btn-delete" title="Excluir" onclick="return confirm('Confirma exclusão?')"><i class="fa fa-trash"></i></a>
            </td>
          </tr>
          <%
                }
            } else {
          %>
          <tr><td colspan="9" class="no-data">Nenhum livro encontrado.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
