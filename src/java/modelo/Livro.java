package modelo;

public class Livro {
    private int id;
    private String titulo;
    private String autor;
    private String editora;
    private int anoPublicacao;
    private String isbn;
    private int quantidadeDisponivel;
    private String categoria;
    private String descricao;
    private int quantidadeEmprestada;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public String getEditora() { return editora; }
    public void setEditora(String editora) { this.editora = editora; }

    public int getAnoPublicacao() { return anoPublicacao; }
    public void setAnoPublicacao(int anoPublicacao) { this.anoPublicacao = anoPublicacao; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public int getQuantidadeDisponivel() { return quantidadeDisponivel; }
    public void setQuantidadeDisponivel(int quantidadeDisponivel) { this.quantidadeDisponivel = quantidadeDisponivel; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public int getQuantidadeEmprestada() { return quantidadeEmprestada; }
    public void setQuantidadeEmprestada(int quantidadeEmprestada) { this.quantidadeEmprestada = quantidadeEmprestada; }
    
    public int getQuantidade() { return quantidadeDisponivel + quantidadeEmprestada; }
}