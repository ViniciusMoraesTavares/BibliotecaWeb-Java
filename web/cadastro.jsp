<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Cadastro de Novo Usuário</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/login.css">
</head>
<body>

    <div class="tela">
        <h1>Cadastro de Novo Usuário</h1>

        <div class="container">
            <form action="cadastro" method="post">
                <h2>Cadastre-se</h2>

                <label>Nome:</label>
                <input type="text" name="nome" placeholder="Digite seu nome" required/>

                <label>Email:</label>
                <input type="email" name="email" placeholder="Digite seu email" required/>
                
                <label>Senha:</label>
                <input type="password" name="senha" placeholder="Crie uma senha" required/>

                <label>Telefone:</label>
                <input type="text" name="telefone" placeholder="Digite seu telefone"/>

                <label>Endereço:</label>
                <input type="text" name="endereco" placeholder="Digite seu endereço" />

                <label>Tipo de Usuário:</label>
                <div class="radio-group">
                    <label>
                        <input type="radio" name="tipo_usuario" value="ESTUDANTE" required />
                        Estudante
                    </label>
                    <label>
                        <input type="radio" name="tipo_usuario" value="PROFESSOR" />
                        Professor
                    </label>
                    <label>
                        <input type="radio" name="tipo_usuario" value="FUNCIONARIO" />
                        Funcionário
                    </label>
                </div>
                
                <input type="hidden" name="data_cadastro" id="data_cadastro" />

                <button type="submit">Cadastrar</button>

                <p>Já tem uma conta? <a href="login.jsp">Faça login</a></p>

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
            
    <script>
      window.onload = function() {
        const dataInput = document.getElementById('data_cadastro');
        if (dataInput) {
          const hoje = new Date().toISOString().split('T')[0];
          dataInput.value = hoje;
        }
      };
    </script>

</body>
</html>
