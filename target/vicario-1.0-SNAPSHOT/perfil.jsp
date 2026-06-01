<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpSession, java.sql.*" %>
<%
    HttpSession sessions = request.getSession(false);
    String nome = null;
    String email = null;
    String contacto = null;


    if (sessions != null) {
        nome = (String) sessions.getAttribute("nome");
        email = (String) sessions.getAttribute("email");
        contacto = (String) sessions.getAttribute("contacto");
    }


    if (nome == null || email == null || contacto == null) {
        response.sendRedirect("pagelogin.jsp");
        return;
    }
    Integer id_email = (Integer) session.getAttribute("nomeUtilizador");
    boolean adm = false;
    boolean funcionario = false;

    String urldb = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String dbUser = "vicario";
    String dbPassword = "MarceloMoura123";
    if (id_email != null) {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            try (Connection connect = DriverManager.getConnection(urldb, dbUser, dbPassword)) {
                String sql = "SELECT COUNT(*) FROM administrador WHERE id_email = ?";
                String sql2 = "SELECT COUNT(*) FROM funcionario WHERE id_email = ?";

                try (PreparedStatement stmt = connect.prepareStatement(sql);
                     PreparedStatement stmt2 = connect.prepareStatement(sql2)) {

                    stmt.setInt(1, id_email);
                    stmt2.setInt(1, id_email);

                    try (ResultSet rs = stmt.executeQuery();
                         ResultSet rs2 = stmt2.executeQuery()) {

                        if (rs.next() && rs.getInt(1) > 0) {
                            adm = true;
                        }

                        if (rs2.next() && rs2.getInt(1) > 0) {
                            funcionario = true;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Erro ao ligar à base de dados.</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-PT">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vicario</title>
    <link rel="stylesheet" href="Css/style.css">
    <!--Fonte de Letra-->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap" rel="stylesheet">
    <!--Ícones-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<header>
    <h1><a href="index.jsp" class="title">Vicario</a></h1>
    <nav class="nav_em">
        <%
            if (adm) {
        %>
        <a href="estatisticas_restaurante.jsp" class="admin-btn">Admin</a>
        <%
        } else if (funcionario) {
        %>
        <a href="planta_restaurante.jsp" class="funcionario-btn">Funcionário</a>
        <%
            }
        %>
        <div class="dropdown">
            <a class="dropbtn">Ementas ▼</a>
            <div class="dropdown-content">
                <a href="massas.jsp">Massas</a>
                <a href="pizzas.jsp">Pizzas</a>
                <a href="carnes.jsp">Carnes</a>
                <a href="entradas.jsp">Entradas</a>
                <a href="sobremesas.jsp">Sobremesas</a>
                <a href="bebidas.jsp">Bebidas</a>
            </div>
        </div>
        <a href="about.jsp">Sobre Nós</a>
        <a href="pedidotakeaway.jsp"><i class="fa fa-shopping-cart icon"></i></a>
        <a href="perfil.jsp"><i class="fa fa-user-o icon_em"></i></a>
    </nav>
</header>
<div class="box">
    <div class="content_box">
        <div class="perfil_txt">
            <p>Perfil</p>
        </div>
        <div class="nome">
            <p>Nome: <%= nome %></p>
        </div>
        <div class="contacto">
            <p>Contacto: <%= contacto %></p>
        </div>
        <div class="email">
            <p>Endereço de Email: <%= email %></p>
        </div>
        <a href="logout.jsp"><button class="button_terminar">Sair</button></a>
    </div>
</div>
<footer class="footer">
    <div class="footer-container">
        <div class="footer-section">
            <h3>Vicario</h3>
            <div class="social-icon">
                <a href="https://www.instagram.com/instagram/" target="_blank"><i class="fa fa-instagram"></i></a>
                <a href="https://www.facebook.com/Cristiano?locale=ms_MY" target="_blank"><i class="fa fa-facebook"></i></a>
            </div>
        </div>
        <div class="footer-section">
            <h3>Categorias</h3>
            <div class="categories-grid">
                <ul class="categories-column">
                    <li><a href="massas.jsp">Massas</a></li>
                    <li><a href="pizzas.jsp">Pizzas</a></li>
                    <li><a href="carnes.jsp">Carnes</a></li>
                </ul>
                <ul class="categories-column">
                    <li><a href="entradas.jsp">Entradas</a></li>
                    <li><a href="sobremesas.jsp">Sobremesas</a></li>
                    <li><a href="bebidas.jsp">Bebidas</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-section">
            <h3>Localização e Contacto</h3>
            <p>Rua das Flores, Porto</p>
            <p>224838743</p>
        </div>
    </div>
</footer>
</body>
</html>