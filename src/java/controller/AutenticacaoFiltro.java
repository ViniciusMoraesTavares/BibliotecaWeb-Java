package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter("/*")
public class AutenticacaoFiltro implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String url = request.getRequestURI();

        boolean recursoPublico =
           url.endsWith("login.jsp") ||
           url.endsWith("/login") ||
           url.endsWith("/logout") || 
           url.endsWith("cadastro.jsp") || 
           url.contains("/cadastro") ||
           url.contains("/css") ||
           url.contains("/js") ||
           url.contains("/styles/") ||
           url.endsWith("teste.jsp");

        boolean logado = (session != null && session.getAttribute("usuarioLogado") != null);

        if (logado || recursoPublico) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
