package controller;

import dao.UsuarioDAO;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/usuario")
public class UsuarioServlet extends BaseServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");

        try {
            switch (acao) {
                case "listar" -> listarUsuarios(request, response);
                case "novo" -> mostrarFormularioNovo(request, response);
                case "editar" -> mostrarFormularioEdicao(request, response);
                case "deletar" -> deletarUsuario(request, response);
                case "buscar" -> buscarUsuario(request, response);
                default -> redirecionarComMensagem(request, response, "index.jsp", "Ação inválida.");
            }
        } catch (Exception e) {
            tratarErro(e, request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");

        try {
            if ("inserir".equals(acao)) {
                inserirUsuario(request, response);
            } else if ("atualizar".equals(acao)) {
                atualizarUsuario(request, response);
            } else {
                redirecionarComMensagem(request, response, "index.jsp", "Ação inválida.");
            }
        } catch (Exception e) {
            tratarErro(e, request, response);
        }
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException, ClassNotFoundException {

        List<Usuario> lista = usuarioDAO.listarTodos();
        request.setAttribute("listaUsuarios", lista);

        String mensagem = (String) request.getSession().getAttribute("mensagem");
        if (mensagem != null) {
            request.setAttribute("mensagem", mensagem);
            request.getSession().removeAttribute("mensagem");
        }

        encaminhar(request, response, "usuarios/usuario-listar.jsp");
    }
    
    private void mostrarFormularioNovo(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    encaminhar(request, response, "usuarios/usuario-form.jsp");
}


    private void inserirUsuario(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ClassNotFoundException {

        Usuario usuario = criarUsuarioDoRequest(request);
        usuarioDAO.inserir(usuario);

        redirecionarComMensagem(request, response, "usuario?acao=listar", "Usuário inserido com sucesso!");
    }

    private void atualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ClassNotFoundException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuarioExistente = usuarioDAO.buscarPorId(id);

        if (usuarioExistente == null) {
            redirecionarComMensagem(request, response, "usuario?acao=listar", "Usuário não encontrado.");
            return;
        }

        Usuario usuario = criarUsuarioDoRequest(request);
        usuario.setId(id);

        // Verificar a senha
        String senha = request.getParameter("senha");

        if (senha == null || senha.trim().isEmpty()) {
            // Se não informou uma nova senha, mantém a senha atual
            usuario.setSenha(usuarioExistente.getSenha());
        } else {
            // Senha nova informada
            usuario.setSenha(senha);
        }

        usuarioDAO.atualizar(usuario);

        redirecionarComMensagem(request, response, "usuario?acao=listar", "Usuário atualizado com sucesso!");
    }


    private void deletarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));

        if (usuarioDAO.possuiEmprestimos(id)) {
            redirecionarComMensagem(
                request, response,
                "usuario?acao=listar",
                "Não é possível excluir o usuário. Existem empréstimos associados."
            );
            return;
        }

        try {
            usuarioDAO.deletar(id);
            redirecionarComMensagem(
                request, response,
                "usuario?acao=listar",
                "Usuário excluído com sucesso!"
            );
        } catch (SQLException e) {
            redirecionarComMensagem(
                request, response,
                "usuario?acao=listar",
                "Erro ao excluir usuário: " + e.getMessage()
            );
        }
    }

    private void mostrarFormularioEdicao(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException, ClassNotFoundException {

        int id = Integer.parseInt(request.getParameter("id"));
        Usuario usuario = usuarioDAO.buscarPorId(id);
        request.setAttribute("usuario", usuario);

        encaminhar(request, response, "usuarios/usuario-form.jsp");
    }

    private Usuario criarUsuarioDoRequest(HttpServletRequest request) {
        Usuario usuario = new Usuario();
        usuario.setNome(request.getParameter("nome"));
        usuario.setEmail(request.getParameter("email"));
        usuario.setTelefone(request.getParameter("telefone"));
        usuario.setEndereco(request.getParameter("endereco"));
        usuario.setTipoUsuario(request.getParameter("tipo_usuario"));
        usuario.setSenha(request.getParameter("senha"));

        try {
            String dataStr = request.getParameter("data_cadastro");
            Date data = new SimpleDateFormat("yyyy-MM-dd").parse(dataStr);
            usuario.setDataCadastro(data);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return usuario;
    }
    
    private void buscarUsuario(HttpServletRequest request, HttpServletResponse response) 
              throws ServletException, IOException {
        String filtro = request.getParameter("filtro");

        try {
            List<Usuario> lista = usuarioDAO.buscarPorNome(filtro);
            request.setAttribute("listaUsuarios", lista);
            encaminhar(request, response, "usuarios/usuario-listar.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao buscar usuários: " + e.getMessage());
            request.getRequestDispatcher("erro.jsp").forward(request, response);
        }
    }
}
