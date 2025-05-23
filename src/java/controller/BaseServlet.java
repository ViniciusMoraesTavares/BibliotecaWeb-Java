package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public abstract class BaseServlet extends HttpServlet {
    
    protected void encaminhar(HttpServletRequest request, HttpServletResponse response, String pagina)
            throws ServletException, IOException {
        request.getRequestDispatcher(pagina).forward(request, response);
    }

    protected void redirecionarComMensagem(HttpServletRequest request, HttpServletResponse response, String url, String mensagem)
            throws IOException {
        request.getSession().setAttribute("mensagem", mensagem);
        response.sendRedirect(url);
    }

    protected void tratarErro(Exception e, HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
       e.printStackTrace();
       request.setAttribute("erroMensagem", e.getMessage());
       request.setAttribute("stackTrace", e.getStackTrace());
       encaminhar(request, response, "erro.jsp");
   }

    protected int parseInt(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    protected Date parseDate(String valor, String formato) {
        try {
            return new SimpleDateFormat(formato).parse(valor);
        } catch (ParseException | NullPointerException e) {
            return null;
        }
    }

    protected String getParametro(HttpServletRequest request, String nome) {
        String valor = request.getParameter(nome);
        return valor != null ? valor.trim() : "";
    }

    protected boolean parametroPreenchido(HttpServletRequest request, String nome) {
        String valor = request.getParameter(nome);
        return valor != null && !valor.trim().isEmpty();
    }
    
    protected Integer parseIntOrNull(String valor) {
        if (valor != null && !valor.isEmpty()) {
            try {
                return Integer.parseInt(valor);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
    
    protected boolean isDataValida(Date dataEmprestimo, Date dataDevolucao) {
        if (dataEmprestimo == null || dataDevolucao == null) {
            return true;
        }
        return !dataDevolucao.before(dataEmprestimo);
    }
}