package dao;

import modelo.Usuario;
import util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public void inserir(Usuario usuario) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO usuarios (nome, email, telefone, endereco, tipo_usuario, data_cadastro, senha) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getTelefone());
            stmt.setString(4, usuario.getEndereco());
            stmt.setString(5, usuario.getTipoUsuario());
            stmt.setDate(6, new java.sql.Date(usuario.getDataCadastro().getTime()));
            stmt.setString(7, usuario.getSenha());

            stmt.executeUpdate();
        }
    }

    public void atualizar(Usuario usuario) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE usuarios SET nome=?, email=?, telefone=?, endereco=?, tipo_usuario=?, senha=? WHERE id=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getTelefone());
            stmt.setString(4, usuario.getEndereco());
            stmt.setString(5, usuario.getTipoUsuario());
            stmt.setString(6, usuario.getSenha());
            stmt.setInt(7, usuario.getId());

            stmt.executeUpdate();
        }
    }

    public void deletar(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM usuarios WHERE id=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Usuario> listarTodos() throws SQLException, ClassNotFoundException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";

        try (Connection conn = ConnectionFactory.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario usuario = montarUsuario(rs);
                lista.add(usuario);
            }
        }
        return lista;
    }

    public List<Usuario> buscarPorNome(String nome) throws SQLException, ClassNotFoundException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE nome LIKE ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + nome + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Usuario usuario = montarUsuario(rs);
                lista.add(usuario);
            }
        }
        return lista;
    }

    public Usuario buscarPorId(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM usuarios WHERE id=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return montarUsuario(rs);
            }
        }
        return null;
    }

    public Usuario buscarPorEmail(String email) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM usuarios WHERE email=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return montarUsuarioComSenha(rs);
            }
        }
        return null;
    }

    private Usuario montarUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("id"));
        usuario.setNome(rs.getString("nome"));
        usuario.setEmail(rs.getString("email"));
        usuario.setTelefone(rs.getString("telefone"));
        usuario.setEndereco(rs.getString("endereco"));
        usuario.setTipoUsuario(rs.getString("tipo_usuario"));
        usuario.setDataCadastro(rs.getDate("data_cadastro"));
        return usuario;
    }

    private Usuario montarUsuarioComSenha(ResultSet rs) throws SQLException {
        Usuario usuario = montarUsuario(rs);
        usuario.setSenha(rs.getString("senha"));
        return usuario;
    }
    
    public boolean possuiEmprestimos(int idUsuario) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM emprestimos WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

}
