package dao;

import modelo.Emprestimo;
import modelo.Emprestimo.StatusEmprestimo;
import modelo.Livro;
import modelo.Usuario;
import util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmprestimoDAO {

    public void inserir(Emprestimo emprestimo) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO emprestimos (id_usuario, id_livro, data_emprestimo, data_devolucao_prevista, data_devolucao_real, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, emprestimo.getIdUsuario());
            stmt.setInt(2, emprestimo.getIdLivro());
            stmt.setDate(3, new java.sql.Date(emprestimo.getDataEmprestimo().getTime()));
            stmt.setDate(4, new java.sql.Date(emprestimo.getDataDevolucaoPrevista().getTime()));

            if (emprestimo.getDataDevolucaoReal() != null) {
                stmt.setDate(5, new java.sql.Date(emprestimo.getDataDevolucaoReal().getTime()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            stmt.setString(6, emprestimo.getStatus().name());

            stmt.executeUpdate();
        }
    }

    public void atualizar(Emprestimo emprestimo) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE emprestimos SET id_usuario = ?, id_livro = ?, data_emprestimo = ?, data_devolucao_prevista = ?, data_devolucao_real = ?, status = ? WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, emprestimo.getIdUsuario());
            stmt.setInt(2, emprestimo.getIdLivro());
            stmt.setDate(3, new java.sql.Date(emprestimo.getDataEmprestimo().getTime()));
            stmt.setDate(4, new java.sql.Date(emprestimo.getDataDevolucaoPrevista().getTime()));

            if (emprestimo.getDataDevolucaoReal() != null) {
                stmt.setDate(5, new java.sql.Date(emprestimo.getDataDevolucaoReal().getTime()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            stmt.setString(6, emprestimo.getStatus().name());
            stmt.setInt(7, emprestimo.getId());

            stmt.executeUpdate();
        }
    }

    public void deletar(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM emprestimos WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public Emprestimo buscarPorId(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM emprestimos WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearEmprestimo(rs);
                }
            }
        }
        return null;
    }

    public List<Emprestimo> listarTodos() throws SQLException, ClassNotFoundException {
        List<Emprestimo> lista = new ArrayList<>();
        String sql = "SELECT * FROM emprestimos";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearEmprestimo(rs));
            }
        }
        return lista;
    }

    private Emprestimo mapearEmprestimo(ResultSet rs) throws SQLException {
        Emprestimo emprestimo = new Emprestimo();
        emprestimo.setId(rs.getInt("id"));
        emprestimo.setIdUsuario(rs.getInt("id_usuario"));
        emprestimo.setIdLivro(rs.getInt("id_livro"));
        emprestimo.setDataEmprestimo(rs.getDate("data_emprestimo"));
        emprestimo.setDataDevolucaoPrevista(rs.getDate("data_devolucao_prevista"));
        emprestimo.setDataDevolucaoReal(rs.getDate("data_devolucao_real"));

        String statusStr = rs.getString("status");
        if (statusStr != null) {
            emprestimo.setStatus(StatusEmprestimo.valueOf(statusStr));
        } else {
            emprestimo.setStatus(StatusEmprestimo.ATIVO);
        }

        return emprestimo;
    }

    public List<Emprestimo> buscarPorPeriodo(Date dataInicio, Date dataFim) throws SQLException, ClassNotFoundException {
        List<Emprestimo> lista = new ArrayList<>();

        String sql = """
            SELECT e.id, e.data_emprestimo, u.nome AS nome_usuario, l.titulo AS titulo_livro
            FROM emprestimos e
            INNER JOIN usuarios u ON e.id_usuario = u.id
            INNER JOIN livros l ON e.id_livro = l.id
            WHERE e.data_emprestimo BETWEEN ? AND ?
            ORDER BY e.data_emprestimo
        """;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(dataInicio.getTime()));
            stmt.setDate(2, new java.sql.Date(dataFim.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Emprestimo e = new Emprestimo();
                    e.setId(rs.getInt("id"));
                    e.setDataEmprestimo(rs.getDate("data_emprestimo"));

                    Usuario u = new Usuario();
                    u.setNome(rs.getString("nome_usuario"));
                    e.setUsuario(u);

                    Livro l = new Livro();
                    l.setTitulo(rs.getString("titulo_livro"));
                    e.setLivro(l);

                    lista.add(e);
                }
            }
        }

        return lista;
    }
    
    public List<Emprestimo> listarPorFiltros(Integer idUsuario,
                                         Integer idLivro,
                                         StatusEmprestimo status,
                                         java.sql.Date dataInicio,
                                         java.sql.Date dataFim)
        throws SQLException, ClassNotFoundException {

        List<Emprestimo> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT e.id,
                   e.data_emprestimo,
                   e.data_devolucao_prevista,
                   e.data_devolucao_real,
                   e.status,
                   u.id   AS usuario_id,
                   u.nome AS nome_usuario,
                   l.id   AS livro_id,
                   l.titulo AS titulo_livro
            FROM emprestimos e
            JOIN usuarios u ON e.id_usuario = u.id
            JOIN livros   l ON e.id_livro   = l.id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (idUsuario != null) {
            sql.append(" AND e.id_usuario = ? ");
            params.add(idUsuario);
        }
        if (idLivro != null) {
            sql.append(" AND e.id_livro = ? ");
            params.add(idLivro);
        }
        if (status != null) {
            sql.append(" AND e.status = ? ");
            params.add(status.name());
        }
        if (dataInicio != null) {
            sql.append(" AND e.data_emprestimo >= ? ");
            params.add(dataInicio);
        }
        if (dataFim != null) {
            sql.append(" AND e.data_emprestimo <= ? ");
            params.add(dataFim);
        }

        sql.append(" ORDER BY e.data_emprestimo DESC");

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Emprestimo e = new Emprestimo();
                    e.setId(rs.getInt("id"));
                    e.setDataEmprestimo(rs.getDate("data_emprestimo"));
                    e.setDataDevolucaoPrevista(rs.getDate("data_devolucao_prevista"));
                    e.setDataDevolucaoReal(rs.getDate("data_devolucao_real"));
                    e.setStatus(StatusEmprestimo.valueOf(rs.getString("status")));

                    Usuario u = new Usuario();
                    u.setId(rs.getInt("usuario_id"));
                    u.setNome(rs.getString("nome_usuario"));
                    e.setUsuario(u);

                    Livro l = new Livro();
                    l.setId(rs.getInt("livro_id"));
                    l.setTitulo(rs.getString("titulo_livro"));
                    e.setLivro(l);

                    lista.add(e);
                }
            }
        }

        return lista;
    }
       public int contarEmprestimosAtivosPorLivro(int idLivro) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM emprestimos WHERE id_livro = ? AND data_devolucao_real IS NULL";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idLivro);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
