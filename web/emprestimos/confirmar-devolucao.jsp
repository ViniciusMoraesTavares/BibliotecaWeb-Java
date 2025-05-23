<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Confirmar Devolução</title>
  <link rel="stylesheet" href="styles/emprestimo-confirm.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
</head>
<body>
  <div class="card">
    <h2 class="page-title">
      <i class="fa fa-undo"></i> Confirmar Devolução
    </h2>

    <form action="emprestimo" method="post" class="formulario">
      <input type="hidden" name="acao" value="confirmarDevolucao"/>
      <input type="hidden" name="id"    value="<%= ((modelo.Emprestimo)request.getAttribute("emprestimo")).getId() %>"/>

      <label for="status">Selecione o status da devolução:</label>
      <select id="status" name="status" required>
        <option value="DEVOLVIDO">Devolvido</option>
        <option value="ATRASADO">Atrasado</option>
      </select>

      <div class="form-actions">
        <button type="submit" class="btn-primary">
          <i class="fa fa-check"></i> Confirmar
        </button>
        <a href="emprestimo?acao=listar" class="btn-secondary">
          <i class="fa fa-times"></i> Cancelar
        </a>
      </div>
    </form>
  </div>
</body>
</html>
