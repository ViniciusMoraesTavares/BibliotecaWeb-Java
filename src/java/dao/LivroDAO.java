package dao;

import util.ConnectionFactory;
import modelo.Livro;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LivroDAO {

    public void inserir(Livro livro) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO livros (titulo, autor, editora, ano_publicacao, isbn, quantidade_disponivel, categoria, descricao) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setString(3, livro.getEditora());
            stmt.setInt(4, livro.getAnoPublicacao());
            stmt.setString(5, livro.getIsbn());
            stmt.setInt(6, livro.getQuantidadeDisponivel());
            stmt.setString(7, livro.getCategoria());
            stmt.setString(8, livro.getDescricao());

            stmt.executeUpdate();
        }
    }

    public void atualizar(Livro livro) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE livros SET titulo=?, autor=?, editora=?, ano_publicacao=?, isbn=?, quantidade_disponivel=?, categoria=?, descricao=? WHERE id=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setString(3, livro.getEditora());
            stmt.setInt(4, livro.getAnoPublicacao());
            stmt.setString(5, livro.getIsbn());
            stmt.setInt(6, livro.getQuantidadeDisponivel());
            stmt.setString(7, livro.getCategoria());
            stmt.setString(8, livro.getDescricao());
            stmt.setInt(9, livro.getId());

            stmt.executeUpdate();
        }
    }

    public void deletar(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM livros WHERE id=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public Livro buscarPorId(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM livros WHERE id=?";
        Livro livro = null;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    livro = new Livro();
                    livro.setId(rs.getInt("id"));
                    livro.setTitulo(rs.getString("titulo"));
                    livro.setAutor(rs.getString("autor"));
                    livro.setEditora(rs.getString("editora"));
                    livro.setAnoPublicacao(rs.getInt("ano_publicacao"));
                    livro.setIsbn(rs.getString("isbn"));
                    livro.setQuantidadeDisponivel(rs.getInt("quantidade_disponivel"));
                    livro.setCategoria(rs.getString("categoria"));
                    livro.setDescricao(rs.getString("descricao"));
                }
            }
        }
        return livro;
    }

    public List<Livro> listarTodos() throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM livros ORDER BY titulo";
        List<Livro> lista = new ArrayList<>();

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Livro livro = new Livro();
                livro.setId(rs.getInt("id"));
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setEditora(rs.getString("editora"));
                livro.setAnoPublicacao(rs.getInt("ano_publicacao"));
                livro.setIsbn(rs.getString("isbn"));
                livro.setQuantidadeDisponivel(rs.getInt("quantidade_disponivel"));
                livro.setCategoria(rs.getString("categoria"));
                livro.setDescricao(rs.getString("descricao"));
                lista.add(livro);
            }
        }
        return lista;
    }

    public List<Livro> buscarPorFiltro(String filtro) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM livros WHERE titulo LIKE ? OR autor LIKE ? OR categoria LIKE ? ORDER BY titulo";
        List<Livro> lista = new ArrayList<>();
        String filtroLike = "%" + filtro + "%";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, filtroLike);
            stmt.setString(2, filtroLike);
            stmt.setString(3, filtroLike);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Livro livro = new Livro();
                    livro.setId(rs.getInt("id"));
                    livro.setTitulo(rs.getString("titulo"));
                    livro.setAutor(rs.getString("autor"));
                    livro.setEditora(rs.getString("editora"));
                    livro.setAnoPublicacao(rs.getInt("ano_publicacao"));
                    livro.setIsbn(rs.getString("isbn"));
                    livro.setQuantidadeDisponivel(rs.getInt("quantidade_disponivel"));
                    livro.setCategoria(rs.getString("categoria"));
                    livro.setDescricao(rs.getString("descricao"));
                    lista.add(livro);
                }
            }
        }
        return lista;
    }
    
    public boolean possuiEmprestimos(int idLivro) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM emprestimos WHERE id_livro = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idLivro);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    public List<Livro> buscarPorTituloAutorCategoria(String filtro) throws SQLException, ClassNotFoundException {
        List<Livro> lista = new ArrayList<>();
        String sql = "SELECT * FROM livros WHERE titulo LIKE ? OR autor LIKE ? OR categoria LIKE ? ORDER BY titulo";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String parametro = "%" + filtro + "%";
            stmt.setString(1, parametro);
            stmt.setString(2, parametro);
            stmt.setString(3, parametro);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Livro livro = new Livro();
                livro.setId(rs.getInt("id"));
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setEditora(rs.getString("editora"));
                livro.setAnoPublicacao(rs.getInt("ano_publicacao"));
                livro.setIsbn(rs.getString("isbn"));
                livro.setQuantidadeDisponivel(rs.getInt("quantidade_disponivel"));
                livro.setCategoria(rs.getString("categoria"));
                livro.setDescricao(rs.getString("descricao"));
                lista.add(livro);
            }
        }
        return lista;
    }
    
    public int contarEmprestimosAtivosPorLivro(int idLivro) throws SQLException, ClassNotFoundException {
       String sql = "SELECT COUNT(*) FROM emprestimos WHERE id_livro = ? AND data_devolucao IS NULL";
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
