<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erro</title>
</head>
<body>
    <h2>Ocorreu um erro!</h2>

    <c:if test="${not empty erroMensagem}">
        <p><strong>Mensagem:</strong> ${erroMensagem}</p>
    </c:if>

    <c:if test="${empty erroMensagem && not empty exception}">
        <p><strong>Mensagem da exceção:</strong> ${exception.message}</p>
    </c:if>

    <c:if test="${not empty stackTrace}">
        <h3>Detalhes do erro:</h3>
        <pre style="background-color:#f0f0f0; padding:10px; border:1px solid #ccc;">
<c:forEach var="elem" items="${stackTrace}">
    ${elem}<br/>
</c:forEach>
        </pre>
    </c:if>

    <p><a href="index.jsp">Voltar para o início</a></p>
</body>
</html>