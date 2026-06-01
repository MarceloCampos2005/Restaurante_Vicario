<%@ page contentType="text/html;charset=UTF-8" language="java" import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*" %>

<%
    // Obter os parâmetros do formulário
    String username = request.getParameter("nome-utilizador");
    String password = request.getParameter("senha");

    // Dados da base de dados
    String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
    String dbUser = "vicario";
    String dbPassword = "MarceloMoura123";

    // Carregar o driver MariaDB
    try {
        Class.forName("org.mariadb.jdbc.Driver");

        // Conectar à base de dados
        try (Connection connect = DriverManager.getConnection(url, dbUser, dbPassword)) {

            String sql = "SELECT * FROM utilizador WHERE email = ? AND pass = ?";

            try (PreparedStatement stmt = connect.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    // Se encontrar o utilizador, recupera dados
                    String contacto = rs.getString("contacto");
                    String email = rs.getString("email");
                    int id_email = rs.getInt("id_email");
                    String first_name = rs.getString("prim_nome");
                    String last_name = rs.getString("ult_nome");

                    HttpSession sessions = request.getSession();
                    sessions.setAttribute("nomeUtilizador", id_email);
                    sessions.setAttribute("nome", first_name + " " + last_name);
                    sessions.setAttribute("email", email);
                    sessions.setAttribute("contacto", contacto);
                    response.sendRedirect("perfil.jsp");
                    return;
                } else {
                    request.setAttribute("popupStatus", "notLogged");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("pagelogin.jsp");
                    dispatcher.forward(request, response);
                    return;

                }
            } catch (Exception e) {
                // Caso haja erro ao conectar à base de dados
                e.printStackTrace();
                out.println("<p>Erro ao ligar à base de dados.</p>");
            }
        } catch (Exception e) {
            // Caso haja erro ao conectar à base de dados
            e.printStackTrace();
            out.println("<p>Erro ao ligar à base de dados.</p>");
        }
    } catch (Exception e) {
        // Caso haja erro ao conectar à base de dados
        e.printStackTrace();
        out.println("<p>Erro ao ligar à base de dados.</p>");
    }
%>
