package controller;

import dao.EmprestimoDAO;
import dao.LivroDAO;
import modelo.Livro;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/livro")
public class LivroServlet extends BaseServlet {

    private LivroDAO livroDAO;
    private EmprestimoDAO emprestimoDAO;

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        emprestimoDAO = new EmprestimoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acao = getParametro(request, "acao");

        try {
            switch (acao) {
                case "listar" -> listarLivros(request, response);
                case "novo" -> mostrarFormularioNovo(request, response);
                case "editar" -> mostrarFormularioEdicao(request, response);
                case "deletar" -> deletarLivro(request, response);
                case "buscar" -> buscarLivro(request, response);
                default -> redirecionarComMensagem(request, response, "index.jsp", "Ação inválida.");
            }
        } catch (Exception e) {
            tratarErro(e, request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acao = getParametro(request, "acao");

        try {
            switch (acao) {
                case "inserir" -> inserirLivro(request, response);
                case "atualizar" -> atualizarLivro(request, response);
                default -> redirecionarComMensagem(request, response, "index.jsp", "Ação inválida.");
            }
        } catch (Exception e) {
            tratarErro(e, request, response);
        }
    }

    private void listarLivros(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Livro> lista = livroDAO.listarTodos();

        for (Livro livro : lista) {
            int emprestados = emprestimoDAO.contarEmprestimosAtivosPorLivro(livro.getId());
            livro.setQuantidadeEmprestada(emprestados);
        }

        request.setAttribute("listaLivros", lista);
        encaminhar(request, response, "livros/livro-listar.jsp");
    }

    private void mostrarFormularioNovo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        encaminhar(request, response, "livros/livro-form.jsp");
    }

    private void inserirLivro(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Livro livro = criarLivroDoRequest(request);
        livroDAO.inserir(livro);
        redirecionarComMensagem(request, response, "livro?acao=listar", "Livro inserido com sucesso!");
    }

    private void atualizarLivro(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Livro livro = criarLivroDoRequest(request);
        livro.setId(parseInt(request.getParameter("id")));

        // Validação: não permitir quantidade menor que empréstimos ativos
        int emprestados = emprestimoDAO.contarEmprestimosAtivosPorLivro(livro.getId());
        if (livro.getQuantidadeDisponivel() < emprestados) {
            redirecionarComMensagem(request, response, "livro?acao=editar&id=" + livro.getId(),
                    "Erro: A quantidade não pode ser menor que os empréstimos ativos (" + emprestados + ").");
            return;
        }

        livroDAO.atualizar(livro);
        redirecionarComMensagem(request, response, "livro?acao=listar", "Livro atualizado com sucesso!");
    }

    private void deletarLivro(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));

        if (livroDAO.possuiEmprestimos(id)) {
            redirecionarComMensagem(request, response, "livro?acao=listar",
                    "Não é possível deletar o livro. Existem empréstimos associados.");
            return;
        }

        livroDAO.deletar(id);
        redirecionarComMensagem(request, response, "livro?acao=listar", "Livro deletado com sucesso!");
    }

    private void mostrarFormularioEdicao(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));
        Livro livro = livroDAO.buscarPorId(id);

        if (livro == null) {
            redirecionarComMensagem(request, response, "livro?acao=listar", "Livro não encontrado.");
            return;
        }

        int emprestados = emprestimoDAO.contarEmprestimosAtivosPorLivro(id);
        livro.setQuantidadeEmprestada(emprestados);

        request.setAttribute("livro", livro);
        encaminhar(request, response, "livros/livro-form.jsp");
    }

    private Livro criarLivroDoRequest(HttpServletRequest request) {
        Livro livro = new Livro();
        livro.setTitulo(getParametro(request, "titulo"));
        livro.setAutor(getParametro(request, "autor"));
        livro.setEditora(getParametro(request, "editora"));
        livro.setIsbn(getParametro(request, "isbn"));
        livro.setCategoria(getParametro(request, "categoria"));
        livro.setDescricao(getParametro(request, "descricao"));
        livro.setAnoPublicacao(parseInt(request.getParameter("anoPublicacao")));
        livro.setQuantidadeDisponivel(parseInt(request.getParameter("quantidadeDisponivel")));

        return livro;
    }

    private void buscarLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filtro = request.getParameter("filtro");

        try {
            List<Livro> lista = livroDAO.buscarPorTituloAutorCategoria(filtro);

            for (Livro livro : lista) {
                int emprestados = emprestimoDAO.contarEmprestimosAtivosPorLivro(livro.getId());
                livro.setQuantidadeEmprestada(emprestados);
            }

            request.setAttribute("listaLivros", lista);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao buscar livros: " + e.getMessage());
        }

        request.getRequestDispatcher("livros/livro-listar.jsp").forward(request, response);
    }
}
