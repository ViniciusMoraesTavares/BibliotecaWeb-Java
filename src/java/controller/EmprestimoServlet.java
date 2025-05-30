package controller;

import dao.EmprestimoDAO;
import dao.UsuarioDAO;
import dao.LivroDAO;
import modelo.Emprestimo;
import modelo.Emprestimo.StatusEmprestimo;
import modelo.Usuario;
import modelo.Livro;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Arrays;

@WebServlet("/emprestimo")
public class EmprestimoServlet extends BaseServlet {

    private EmprestimoDAO emprestimoDAO;
    private Usuario usuario;
    private Livro livro;

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { this.livro = livro; }

    @Override
    public void init() throws ServletException {
        emprestimoDAO = new EmprestimoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acao = getParametro(request, "acao");

        try {
            switch (acao) {
                case "listar" -> listarEmprestimos(request, response);
                case "listarFiltrado" -> listarFiltrado(request, response);
                case "editar" -> mostrarFormularioEdicao(request, response);
                case "novo" -> mostrarFormularioNovo(request, response);
                case "confirmarDevolucao" -> mostrarConfirmacaoDevolucao(request, response);
                case "devolver" -> devolverEmprestimo(request, response);
                case "deletar" -> deletarEmprestimo(request, response);
                case "relatorio" -> gerarRelatorio(request, response);
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
                case "inserir" -> inserirEmprestimo(request, response);
                case "atualizar" -> atualizarEmprestimo(request, response);
                case "confirmarDevolucao" -> confirmarDevolucao(request, response);
                default -> redirecionarComMensagem(request, response, "index.jsp", "Ação inválida.");
            }
        } catch (Exception e) {
            tratarErro(e, request, response);
        }
    }

    private void listarEmprestimos(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        emprestimoDAO.atualizarStatusAtrasados();
        
        List<Emprestimo> lista = emprestimoDAO.listarTodos();
        request.setAttribute("listaEmprestimos", lista);

        request.setAttribute("listaUsuarios", new UsuarioDAO().listarTodos());
        request.setAttribute("listaLivros",  new LivroDAO().listarTodos());

        encaminhar(request, response, "emprestimos/emprestimo-listar.jsp");
    }

    private void mostrarFormularioNovo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("listaUsuarios", new UsuarioDAO().listarTodos());
            request.setAttribute("listaLivros",  new LivroDAO().listarTodos());
            encaminhar(request, response, "emprestimos/emprestimo-form.jsp");
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar usuários e livros", e);
        }
    }

    private void inserirEmprestimo(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        Emprestimo emprestimo = criarEmprestimoDoRequest(request);

        if (!isDataValida(emprestimo.getDataEmprestimo(), emprestimo.getDataDevolucaoPrevista())) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=novo", "A data de devolução não pode ser anterior à data de empréstimo.");
            return;
        }

        LivroDAO livroDAO = new LivroDAO();
        EmprestimoDAO emprestimoDAO = new EmprestimoDAO();

        Livro livro = livroDAO.buscarPorId(emprestimo.getIdLivro());

        if (livro == null) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=novo", "Livro não encontrado.");
            return;
        }

        int quantidadeDisponivel = livro.getQuantidade() 
                - emprestimoDAO.contarEmprestimosAtivosPorLivro(livro.getId());

        if (quantidadeDisponivel <= 0) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=novo", "Não há unidades disponíveis para empréstimo deste livro.");
            return;
        }

        emprestimoDAO.inserir(emprestimo);
        redirecionarComMensagem(request, response,
            "emprestimo?acao=listar", "Empréstimo registrado com sucesso!");
    }

    private void atualizarEmprestimo(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        Emprestimo emprestimo = criarEmprestimoDoRequest(request);
        emprestimo.setId(parseInt(request.getParameter("id")));

        if (!isDataValida(emprestimo.getDataEmprestimo(), emprestimo.getDataDevolucaoPrevista())) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=editar&id=" + emprestimo.getId(),
                "A data de devolução não pode ser anterior à data de empréstimo.");
            return;
        }

        emprestimoDAO.atualizar(emprestimo);
        redirecionarComMensagem(request, response,
            "emprestimo?acao=listar", "Empréstimo atualizado com sucesso!");
    }

    private void deletarEmprestimo(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));
        emprestimoDAO.deletar(id);
        redirecionarComMensagem(request, response,
            "emprestimo?acao=listar", "Empréstimo deletado com sucesso!");
    }

    private void mostrarConfirmacaoDevolucao(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));
        Emprestimo emprestimo = emprestimoDAO.buscarPorId(id);
        if (emprestimo == null) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=listar", "Empréstimo não encontrado.");
            return;
        }
        request.setAttribute("emprestimo", emprestimo);
        encaminhar(request, response, "emprestimos/confirmar-devolucao.jsp");
    }

    private void confirmarDevolucao(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));
        Emprestimo emprestimo = emprestimoDAO.buscarPorId(id);
        if (emprestimo == null) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=listar", "Empréstimo não encontrado.");
            return;
        }

        String statusParam = getParametro(request, "status").toUpperCase();
        try {
            emprestimo.setStatus(StatusEmprestimo.valueOf(statusParam));
        } catch (IllegalArgumentException e) {
            emprestimo.setStatus(StatusEmprestimo.ATIVO);
        }

        if (emprestimo.getStatus() == StatusEmprestimo.DEVOLVIDO) {
            emprestimo.setDataDevolucaoReal(new Date());
        } else {
            emprestimo.setDataDevolucaoReal(null);
        }

        emprestimoDAO.atualizar(emprestimo);
        redirecionarComMensagem(request, response,
            "emprestimo?acao=listar", "Status da devolução atualizado com sucesso!");
    }
    
    private void devolverEmprestimo(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));
        Emprestimo emprestimo = emprestimoDAO.buscarPorId(id);
        if (emprestimo == null) {
            redirecionarComMensagem(request, response, "emprestimo?acao=listar", "Empréstimo não encontrado.");
            return;
        }

        emprestimo.setStatus(StatusEmprestimo.DEVOLVIDO);
        emprestimo.setDataDevolucaoReal(new Date());
        emprestimoDAO.atualizar(emprestimo);

        redirecionarComMensagem(request, response, "emprestimo?acao=listar", "Empréstimo devolvido com sucesso!");
    }

    private void mostrarFormularioEdicao(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = parseInt(request.getParameter("id"));
        Emprestimo emprestimo = emprestimoDAO.buscarPorId(id);
        if (emprestimo == null) {
            redirecionarComMensagem(request, response,
                "emprestimo?acao=listar", "Empréstimo não encontrado.");
            return;
        }
        request.setAttribute("emprestimo", emprestimo);
        request.setAttribute("listaUsuarios", new UsuarioDAO().listarTodos());
        request.setAttribute("listaLivros",  new LivroDAO().listarTodos());
        encaminhar(request, response, "emprestimos/emprestimo-form.jsp");
    }

    private Emprestimo criarEmprestimoDoRequest(HttpServletRequest request) {
        Emprestimo emprestimo = new Emprestimo();

        emprestimo.setIdUsuario(parseInt(request.getParameter("id_usuario")));
        emprestimo.setIdLivro(parseInt(request.getParameter("id_livro")));

        Date d1 = parseDate(request.getParameter("data_emprestimo"), "yyyy-MM-dd");
        Date d2 = parseDate(request.getParameter("data_devolucao_prevista"), "yyyy-MM-dd");
        Date d3 = parseDate(request.getParameter("data_devolucao_real"), "yyyy-MM-dd");

        emprestimo.setDataEmprestimo(d1);
        emprestimo.setDataDevolucaoPrevista(d2);
        emprestimo.setDataDevolucaoReal(d3);

        String statusParam = getParametro(request, "status").toUpperCase();
        try {
            emprestimo.setStatus(StatusEmprestimo.valueOf(statusParam));
        } catch (IllegalArgumentException e) {
            emprestimo.setStatus(StatusEmprestimo.ATIVO);
        }

        return emprestimo;
    }

    private void gerarRelatorio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String di = request.getParameter("dataInicio");
            String df = request.getParameter("dataFim");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date dInicioUtil  = sdf.parse(di);
            java.util.Date dFimUtil = sdf.parse(df);
            
            java.sql.Date dInicio = new java.sql.Date(dInicioUtil.getTime());
            java.sql.Date dFim = new java.sql.Date(dFimUtil.getTime());

            List<Emprestimo> lista = emprestimoDAO.buscarPorPeriodo(dInicio, dFim);
            request.setAttribute("listaEmprestimos", lista);
            request.setAttribute("dataInicio", di);
            request.setAttribute("dataFim", df);

            request.getRequestDispatcher("emprestimos/emprestimos-relatorio.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensagem", "Erro ao gerar relatório: " + e.getMessage());
            request.getRequestDispatcher("erro.jsp").forward(request, response);
        }
    }

    private void listarFiltrado(HttpServletRequest request, HttpServletResponse response)
        throws Exception { 
        
        emprestimoDAO.atualizarStatusAtrasados();

        System.out.println("id_usuario = " + request.getParameter("id_usuario"));
        System.out.println("Todos os parâmetros:");
        request.getParameterMap().forEach((key, value) -> 
            System.out.println(key + " = " + Arrays.toString(value))
        );

        String idUsuarioStr = request.getParameter("id_usuario");
        String idLivroStr = request.getParameter("id_livro");
        String statusStr = request.getParameter("status");
        String dataInicioStr = request.getParameter("data_inicio");
        String dataFimStr = request.getParameter("data_fim");

        Integer idUsuario = parseIntOrNull(idUsuarioStr);
        Integer idLivro = parseIntOrNull(idLivroStr);

        StatusEmprestimo status = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                status = StatusEmprestimo.valueOf(statusStr.toUpperCase());
            } catch (IllegalArgumentException ignored) {}
        }

        Date dataInicio = parseDate(dataInicioStr, "yyyy-MM-dd");
        Date dataFim = parseDate(dataFimStr, "yyyy-MM-dd");

        java.sql.Date dataInicioSql = (dataInicio != null) ? new java.sql.Date(dataInicio.getTime()) : null;
        java.sql.Date dataFimSql = (dataFim != null) ? new java.sql.Date(dataFim.getTime()) : null;

        List<Emprestimo> lista = emprestimoDAO.listarPorFiltros(idUsuario, idLivro, status, dataInicioSql, dataFimSql);

        request.setAttribute("listaEmprestimos", lista);
        request.setAttribute("listaUsuarios", new UsuarioDAO().listarTodos());
        request.setAttribute("listaLivros", new LivroDAO().listarTodos());

        if (idUsuario != null) {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
            if (usuario == null) {
                request.setAttribute("erro", "Usuário não encontrado.");
                encaminhar(request, response, "erro.jsp");
                return;
            }
            request.setAttribute("usuario", usuario);
        } else {
            request.setAttribute("erro", "ID do usuário não informado.");
            encaminhar(request, response, "erro.jsp"); 
            return;
        }

        request.setAttribute("filtroIdUsuario", idUsuarioStr);
        request.setAttribute("filtroIdLivro", idLivroStr);
        request.setAttribute("filtroStatus", statusStr);
        request.setAttribute("filtroDataInicio", dataInicioStr);
        request.setAttribute("filtroDataFim", dataFimStr);

        encaminhar(request, response, "emprestimos/emprestimos-usuario.jsp");
    } 
}
