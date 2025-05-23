<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Sistema Biblioteca</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/login.css">
</head>
<body>

    <div class="tela">
        <h1>Login - Sistema Biblioteca</h1>

        <div class="container">
            <form action="login" method="post">
                <h2>Login</h2>

                <label>Email:</label>
                <input type="email" name="email" placeholder="Digite seu email" required/>

                <label>Senha:</label>
                <input type="password" name="senha" placeholder="Digite sua senha" required/>

                <button type="submit">Entrar</button>

                <p>Não tem uma conta? <a href="cadastro.jsp">Cadastre-se aqui</a></p>

                <%
                    String mensagem = (String) request.getAttribute("mensagem");
                    if (mensagem != null && !mensagem.isEmpty()) {
                %>
                    <div class="mensagem-erro"><%= mensagem %></div>
                <%
                    }
                %>
            </form>
        </div>
    </div>

</body>
</html>
