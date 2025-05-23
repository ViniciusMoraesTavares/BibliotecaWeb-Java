<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*,java.text.SimpleDateFormat" %>
<html>
<head>
    <title>Lista de Usuários</title>
    <link rel="stylesheet" href="styles/usuarios.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
  <div class="card">
        <%
      String mensagem = (String) request.getAttribute("mensagem");
      if (mensagem != null && !mensagem.isEmpty()) {
    %>
      <div class="mensagem-sucesso"><i class="fa fa-check-circle"></i> <%= mensagem %></div>
    <%
      }
    %>


    <h2 class="page-title">
      <i class="fa fa-users"></i> Lista de Usuários
    </h2>

    <div class="actions">
      <a href="usuario?acao=novo" class="btn-primary"><i class="fa fa-plus"></i> Novo Usuário</a>
      <a href="index.jsp"         class="btn-secondary"><i class="fa fa-arrow-left"></i> Voltar</a>
    </div>
    
    <div class="search-bar">
        <form action="usuario" method="get">
            <input type="hidden" name="acao" value="buscar">
            <input type="text" name="filtro" placeholder="Buscar por nome" required>
            <button type="submit" class="btn-search">
                <i class="fa fa-search"></i> Buscar
            </button>
            <a href="usuario?acao=listar" class="btn-clear">
                <i class="fa fa-times"></i> Limpar
            </a>
        </form>
    </div>

    <div class="table-container">
      <table>
        <thead>
            <tr>
              <th>ID</th>
              <th>Nome</th>
              <th>Email</th>
              <th>Telefone</th>
              <th>Tipo</th>
              <th>Data Cadastro</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
          <%
            List<?> listaUsuarios = (List<?>) request.getAttribute("listaUsuarios");
            if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                for (Object obj : listaUsuarios) {
                    Class<?> cls = obj.getClass();
                    Integer id = (Integer) cls.getMethod("getId").invoke(obj);
                    String nome = (String) cls.getMethod("getNome").invoke(obj);
                    String email = (String) cls.getMethod("getEmail").invoke(obj);
                    String telefone = (String) cls.getMethod("getTelefone").invoke(obj);
                    String tipo = (String) cls.getMethod("getTipoUsuario").invoke(obj);
                    Date dt = (Date) cls.getMethod("getDataCadastro").invoke(obj);
          %>
            <tr>
              <td><%= id %></td>
              <td><%= nome %></td>
              <td><%= email %></td>
              <td><%= telefone %></td>
              <td><%= tipo %></td>
              <td><%= dt != null ? sdf.format(dt) : "" %></td>
              <td class="actions-cell">
                <a href="usuario?acao=editar&id=<%= id %>" class="btn-edit" data-tooltip="Editar">
                  <i class="fa fa-edit"></i>
                </a>
                <a href="emprestimo?acao=listarFiltrado&id_usuario=<%= id %>" class="btn-loan" data-tooltip="Ver Empréstimos">
                  <i class="fa fa-book"></i>
                </a>
                <a href="usuario?acao=deletar&id=<%= id %>" class="btn-delete" data-tooltip="Excluir" onclick="return confirm('Confirma exclusão?')">
                  <i class="fa fa-trash"></i>
                </a>
              </td>
            </tr>
          <%
                }
            } else {
          %>
            <tr><td colspan="8" class="no-data">Nenhum usuário encontrado.</td></tr>
          <%
            }
          %>
          </tbody>
      </table>
    </div>
  </div>
</body>
</html>