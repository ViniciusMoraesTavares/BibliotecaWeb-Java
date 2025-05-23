<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sistema Biblioteca</title>
    <link rel="stylesheet" href="styles/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
   <div class="card">
        <h1>Bem-vindo ao Sistema de Biblioteca</h1>
        <nav>
          <ul class="button-group-top">
            <li class="menu-item">
              <a href="usuario?acao=listar"><i class="fas fa-user"></i> Usuários</a>
              <p class="descricao">Gerencie os usuários cadastrados</p>
            </li>
            <li class="menu-item">
              <a href="livro?acao=listar"><i class="fas fa-book"></i> Livros</a>
              <p class="descricao">Visualize e cadastre livros</p>
            </li>
          </ul>
          <ul class="button-group-bottom">
            <li class="menu-item">
              <a href="emprestimo?acao=listar"><i class="fas fa-handshake"></i> Empréstimos</a>
              <p class="descricao">Controle os empréstimos de livros</p>
            </li>
          </ul>
        </nav>
    </div>

    <a class="logout" href="logout" onclick="return confirm('Deseja realmente sair?')">Sair</a>

    <div>
        <% 
            String mensagem = (String) session.getAttribute("mensagem");
            if(mensagem != null) {
        %>
            <div class="mensagem"><%= mensagem %></div>
        <%
                session.removeAttribute("mensagem");
            }
        %>
    </div>
</body>
</html>
