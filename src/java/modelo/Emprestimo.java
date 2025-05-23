package modelo;

import java.util.Date;

public class Emprestimo {

    public enum StatusEmprestimo {
        ATIVO,
        DEVOLVIDO,
        ATRASADO
    }

    private int id;
    private int idUsuario;
    private int idLivro;
    private Date dataEmprestimo;
    private Date dataDevolucaoPrevista;
    private Date dataDevolucaoReal;
    private StatusEmprestimo status;

    private Usuario usuario;
    private Livro livro;

    public Emprestimo() {
        this.status = StatusEmprestimo.ATIVO;
    }

    public Emprestimo(int idUsuario, int idLivro, Date dataEmprestimo, Date dataDevolucaoPrevista) {
        this.idUsuario = idUsuario;
        this.idLivro = idLivro;
        this.dataEmprestimo = dataEmprestimo;
        this.dataDevolucaoPrevista = dataDevolucaoPrevista;
        this.status = StatusEmprestimo.ATIVO;
    }

    public Emprestimo(int id, int idUsuario, int idLivro, Date dataEmprestimo,
                      Date dataDevolucaoPrevista, Date dataDevolucaoReal, StatusEmprestimo status) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.idLivro = idLivro;
        this.dataEmprestimo = dataEmprestimo;
        this.dataDevolucaoPrevista = dataDevolucaoPrevista;
        this.dataDevolucaoReal = dataDevolucaoReal;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public int getIdLivro() { return idLivro; }
    public void setIdLivro(int idLivro) { this.idLivro = idLivro; }

    public Date getDataEmprestimo() { return dataEmprestimo; }
    public void setDataEmprestimo(Date dataEmprestimo) { this.dataEmprestimo = dataEmprestimo; }

    public Date getDataDevolucaoPrevista() { return dataDevolucaoPrevista; }
    public void setDataDevolucaoPrevista(Date dataDevolucaoPrevista) { this.dataDevolucaoPrevista = dataDevolucaoPrevista; }

    public Date getDataDevolucaoReal() { return dataDevolucaoReal; }
    public void setDataDevolucaoReal(Date dataDevolucaoReal) { this.dataDevolucaoReal = dataDevolucaoReal; }

    public StatusEmprestimo getStatus() { return status; }
    public void setStatus(StatusEmprestimo status) { this.status = status; }

    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }

    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { this.livro = livro; }
    
    public String getTituloLivro() {
    return livro != null ? livro.getTitulo() : "Livro não encontrado";
}

    public String getDataEmprestimoFormatada() {
        return dataEmprestimo != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(dataEmprestimo) : "-";
    }

    public String getDataDevolucaoPrevistaFormatada() {
        return dataDevolucaoPrevista != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(dataDevolucaoPrevista) : "-";
    }

    public String getDataDevolucaoRealFormatada() {
        return dataDevolucaoReal != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(dataDevolucaoReal) : null;
    }


    @Override
    public String toString() {
        return "Emprestimo{" +
                "id=" + id +
                ", idUsuario=" + idUsuario +
                ", idLivro=" + idLivro +
                ", dataEmprestimo=" + dataEmprestimo +
                ", dataDevolucaoPrevista=" + dataDevolucaoPrevista +
                ", dataDevolucaoReal=" + dataDevolucaoReal +
                ", status=" + status +
                ", usuario=" + (usuario != null ? usuario.getId() : "null") +
                ", livro=" + (livro != null ? livro.getId() : "null") +
                '}';
    }
}