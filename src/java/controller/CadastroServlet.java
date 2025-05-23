package controller;

import dao.UsuarioDAO;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Usuario usuario = new Usuario();
            usuario.setNome(request.getParameter("nome"));
            usuario.setEmail(request.getParameter("email"));
            usuario.setTelefone(request.getParameter("telefone"));
            usuario.setEndereco(request.getParameter("endereco"));
            usuario.setTipoUsuario(request.getParameter("tipo_usuario"));

            String dataStr = request.getParameter("data_cadastro");
            Date dataCadastro = new SimpleDateFormat("yyyy-MM-dd").parse(dataStr);
            usuario.setDataCadastro(dataCadastro);

            usuario.setSenha(request.getParameter("senha"));

            UsuarioDAO dao = new UsuarioDAO();
            dao.inserir(usuario);

            request.setAttribute("mensagem", "Usuário cadastrado com sucesso! Faça login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao cadastrar: " + e.getMessage());
            request.getRequestDispatcher("cadastro.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("cadastro.jsp");
    }
}
