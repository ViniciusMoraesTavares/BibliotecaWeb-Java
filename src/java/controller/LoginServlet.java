package controller;

import dao.UsuarioDAO;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        try {
            Usuario usuario = usuarioDAO.buscarPorEmail(email);
            System.out.println("Email recebido: " + email);
            System.out.println("Usuário retornado: " + (usuario != null ? usuario.getNome() : "null"));

            if (usuario != null && validarSenha(senha, usuario)) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("mensagem", "Email ou senha inválidos");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao realizar login: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
    
    private boolean validarSenha(String senhaInformada, Usuario usuario) {
        return usuario.getSenha().equals(senhaInformada);
    }

}
