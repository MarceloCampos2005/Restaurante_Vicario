
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%
    String first_name = request.getParameter("primeiro-nome");
    String last_name = request.getParameter("ultimo-nome");
    String contact = request.getParameter("contact");
    String pass = request.getParameter("password");
    String email = request.getParameter("email");

    if(email == null || email.trim().isEmpty() ||
            first_name == null || first_name.trim().isEmpty() ||
            last_name == null || last_name.trim().isEmpty() ||
            contact == null || contact.trim().isEmpty() ||
            pass == null || pass.trim().isEmpty()) {
        out.print("<h2>Todos os campos são obrigatórios!</h2>");
        return;
    }


    String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String user = "vicario";
    String password = "MarceloMoura123";
    try {
        // Carrega o driver do MariaDB (necessarily para algumas versões do Tomcat)
        Class.forName("org.mariadb.jdbc.Driver");

        try (Connection connect = DriverManager.getConnection(url, user, password)) {
            int idEmail = 0;
            String sql = "INSERT INTO utilizador (email, prim_nome, ult_nome, contacto, pass) " +
                    "VALUES (?, ?, ?, ?, ?)";
            String checkUserSql = "SELECT COUNT(*) FROM utilizador WHERE email = ?";
            PreparedStatement checkStmt = connect.prepareStatement(checkUserSql);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            if(rs.getInt(1) > 0) {
                out.print("<h2>Este nome de utilizador já existe.</h2>");
                return;
            }
            try (PreparedStatement stmt = connect.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, email);
                stmt.setString(2, first_name);
                stmt.setString(3, last_name);
                stmt.setString(4, contact);
                stmt.setString(5, pass);
                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            idEmail = generatedKeys.getInt(1); // ou getLong(1)
                        }
                    }
                }
                String sql1 = "INSERT INTO carrinho (id_email) VALUES (?)";
                PreparedStatement stmt1 = connect.prepareStatement(sql1);
                stmt1.setInt(1, idEmail);
                stmt1.executeUpdate();
            }


            // Guardar os dados na sessão
            HttpSession sessions = request.getSession();

            sessions.setAttribute("nomeUtilizador", idEmail);
            sessions.setAttribute("email", email);
            sessions.setAttribute("nome", first_name + " " + last_name);
            sessions.setAttribute("contacto", contact);
            response.sendRedirect("perfil.jsp");
            return;
        }

    } catch (Exception e) {
        out.print("<h2>Erro ao registar utilizador!</h2>");
        out.print("<pre>" + e.getMessage() + "</pre>");
        e.printStackTrace();

    }

%>
