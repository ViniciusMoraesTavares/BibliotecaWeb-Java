<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>
        <%
            Object usuarioObj = request.getAttribute("usuario");
            out.print(usuarioObj != null ? "Editar Usuário" : "Novo Usuário");
        %>
    </title>
    <link rel="stylesheet" href="styles/usuarios.css">
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

    <h2 class="page-title">
      <i class="fa fa-user"></i>
      <%
        out.print(usuarioObj != null ? "Editar Usuário" : "Novo Usuário");
      %>
    </h2>

    <%
        Object u = usuarioObj;
        boolean edicao = u != null;
        String nome  = edicao ? (String) u.getClass().getMethod("getNome").invoke(u) : "";
        String email = edicao ? (String) u.getClass().getMethod("getEmail").invoke(u) : "";
        String tel   = edicao ? (String) u.getClass().getMethod("getTelefone").invoke(u) : "";
        String end   = edicao ? (String) u.getClass().getMethod("getEndereco").invoke(u) : "";
        String tipo  = edicao ? (String) u.getClass().getMethod("getTipoUsuario").invoke(u) : "";
        String data  = edicao
            ? u.getClass().getMethod("getDataCadastro").invoke(u).toString()
            : LocalDate.now().format(DateTimeFormatter.ISO_DATE);
    %>

    <form action="usuario" method="post" class="formulario">
      <input type="hidden" name="acao" value="<%= edicao ? "atualizar" : "inserir" %>"/>
      <% if (edicao) { %><input type="hidden" name="id" value="<%= u.getClass().getMethod("getId").invoke(u) %>"/><% } %>

      <label for="nome">Nome:</label>
      <input id="nome" type="text" name="nome" value="<%= nome %>" required />

      <label for="email">Email:</label>
      <input id="email" type="email" name="email" value="<%= email %>" required />

      <label for="telefone">Telefone:</label>
      <input id="telefone" type="text" name="telefone" value="<%= tel %>" required />

      <label for="endereco">Endereço:</label>
      <input id="endereco" type="text" name="endereco" value="<%= end %>" required />

      <label>Tipo de Usuário:</label>
      <div class="radio-group">
        <label class="radio-label"><input type="radio" name="tipo_usuario" value="ESTUDANTE" required <%= "ESTUDANTE".equals(tipo)? "checked": "" %>/> Estudante</label>
        <label class="radio-label"><input type="radio" name="tipo_usuario" value="PROFESSOR" required <%= "PROFESSOR".equals(tipo)? "checked": "" %>/> Professor</label>
        <label class="radio-label"><input type="radio" name="tipo_usuario" value="FUNCIONARIO" required <%= "FUNCIONARIO".equals(tipo)? "checked": "" %>/> Funcionário</label>
      </div>

      <input type="hidden" name="data_cadastro" value="<%= data %>" />

      <label for="endereco">Senha:</label>
      <input id="senha" type="password" name="senha" required />

        <div class="form-actions">
            <button type="submit" class="btn-primary"><i class="fa fa-save"></i> Salvar</button>
            <a href="usuario?acao=listar" class="btn-secondary"><i class="fa fa-times"></i> Cancelar</a>
        </div>
    </form>
  </div>
</body>
</html>
