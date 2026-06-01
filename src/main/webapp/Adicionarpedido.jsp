<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    Integer utilizador = (Integer) session.getAttribute("nomeUtilizador");
    String origem = request.getParameter("origem");

    if (utilizador == null) {
        request.setAttribute("popupStatus", "notLogged");
        RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
        dispatcher.forward(request, response);
        return;
    }

    int idGerado = 0;
    try {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
        String user = "vicario";
        String password = "MarceloMoura123";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "SELECT id_carrinho FROM carrinho WHERE id_email= ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, utilizador);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int id_carrinho = rs.getInt("id_carrinho");
                String sql2 = "INSERT INTO pedido (tempo_prep) VALUES (0)";
                PreparedStatement ps = conn.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS);
                ps.executeUpdate();
                ResultSet rs2 = ps.getGeneratedKeys();
                if (rs2.next()) {
                    idGerado = rs2.getInt(1);
                }
                String checkSql = "SELECT COUNT(*) FROM carrinho_prato WHERE id_carrinho = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, id_carrinho);
                ResultSet rs10 = checkStmt.executeQuery();

                if (rs10.next() && rs10.getInt(1) > 0) {
                    String sql_esta1 = "SELECT id_prato, quantidade, preco_venda FROM carrinho_prato WHERE id_carrinho = ?";
                    PreparedStatement ps_esta1 = conn.prepareStatement(sql_esta1);
                    ps_esta1.setInt(1, id_carrinho);
                    ResultSet rs_esta1 = ps_esta1.executeQuery();
                    while (rs_esta1.next()) {
                        int id_prato = rs_esta1.getInt("id_prato");
                        double quantidade_esta_tot = rs_esta1.getDouble("quantidade");
                        double preco_venda = rs_esta1.getDouble("preco_venda");
                        String sql_esta3 = "SELECT nr_doses FROM prato_estatistica WHERE id_tipo_prato = ?";
                        PreparedStatement ps_esta3 = conn.prepareStatement(sql_esta3);
                        if (id_prato == 5 || id_prato == 25 || id_prato == 29) {
                            ps_esta3.setInt(1, 5);
                        } else if (id_prato == 6 || id_prato == 26 || id_prato == 30) {
                            ps_esta3.setInt(1, 6);
                        } else if (id_prato == 7 || id_prato == 27 || id_prato == 31) {
                            ps_esta3.setInt(1, 7);
                        } else if (id_prato == 8 || id_prato == 28 || id_prato == 32) {
                            ps_esta3.setInt(1, 8);
                        } else {
                            ps_esta3.setInt(1, id_prato);
                        }
                        ResultSet rs_esta2 = ps_esta3.executeQuery();
                        if (rs_esta2.next()) {
                            double quantidade_esta = rs_esta2.getDouble("nr_doses");
                            quantidade_esta_tot += quantidade_esta;
                        }
                        String sql_esta2 = "UPDATE prato_estatistica SET nr_doses = ? WHERE id_tipo_prato = ?";
                        PreparedStatement ps_esta2 = conn.prepareStatement(sql_esta2);
                        ps_esta2.setDouble(1, quantidade_esta_tot);
                        if (id_prato == 5 || id_prato == 25 || id_prato == 29) {
                            ps_esta2.setInt(2, 5);
                            ps_esta2.executeUpdate();
                        } else if (id_prato == 6 || id_prato == 26 || id_prato == 30) {
                            ps_esta2.setInt(2, 6);
                            ps_esta2.executeUpdate();
                        } else if (id_prato == 7 || id_prato == 27 || id_prato == 31) {
                            ps_esta2.setInt(2, 7);
                            ps_esta2.executeUpdate();
                        } else if (id_prato == 8 || id_prato == 28 || id_prato == 32) {
                            ps_esta2.setInt(2, 8);
                            ps_esta2.executeUpdate();
                        } else {
                            ps_esta2.setInt(2, id_prato);
                            ps_esta2.executeUpdate();
                        }
                        double faturamento = 0;
                        String sql_esta4 = "SELECT faturamento FROM faturamento_pedido";
                        try (PreparedStatement ps_esta4 = conn.prepareStatement(sql_esta4)) {
                            ResultSet rs_esta4 = ps_esta4.executeQuery();
                            if (rs_esta4.next()) {
                                faturamento = rs_esta4.getDouble("faturamento");
                                faturamento += preco_venda;
                            }
                        }
                        String sql_esta5 = "UPDATE faturamento_pedido SET faturamento = ?";
                        try (PreparedStatement ps_esta5 = conn.prepareStatement(sql_esta5)) {
                            ps_esta5.setDouble(1, faturamento);
                            ps_esta5.executeUpdate();
                        }
                    }
                    String sql3 = "INSERT INTO pedido_prato (nr_pedido, id_prato, quantidade, preco_venda) SELECT ?, id_prato, quantidade, preco_venda FROM carrinho_prato WHERE id_carrinho = ?";
                    PreparedStatement ps2 = conn.prepareStatement(sql3);
                    ps2.setInt(1, idGerado);
                    ps2.setInt(2, id_carrinho);
                    ps2.executeUpdate();
                    String sql4 = "DELETE FROM carrinho_prato WHERE id_carrinho = ?";
                    PreparedStatement ps3 = conn.prepareStatement(sql4);
                    ps3.setInt(1, id_carrinho);
                    ps3.executeUpdate();
                    String sql5 = "UPDATE carrinho SET preco_tot = 0 WHERE id_carrinho = ?";
                    PreparedStatement ps4 = conn.prepareStatement(sql5);
                    ps4.setInt(1, id_carrinho);
                    ps4.executeUpdate();

                    String sql6 = "SELECT quantidade FROM pedido_prato WHERE nr_pedido = ?";
                    PreparedStatement ps5 = conn.prepareStatement(sql6);
                    ps5.setInt(1, idGerado);
                    ResultSet rs3 = ps5.executeQuery();
                    double quantidade_total = 0;
                    while (rs3.next()) {
                        double quantidade = rs3.getDouble("quantidade");
                        quantidade_total += quantidade;
                    }
                    double tempo = 8 * quantidade_total + 4;

                    String sql7 = "UPDATE pedido SET tempo_prep = ? WHERE nr_pedido = ?";
                    PreparedStatement ps6 = conn.prepareStatement(sql7);
                    ps6.setDouble(1, tempo);
                    ps6.setInt(2, idGerado);
                    ps6.executeUpdate();





                } else {
                    request.setAttribute("popupStatus", "notPlates");
                    RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
                    dispatcher.forward(request, response);
                    return;
                }
            }
        }
    } catch (Exception e) {
        // Caso haja erro ao conectar à base de dados
        e.printStackTrace();
        out.println("<p>Erro ao ligar à base de dados.</p>");
    }
    request.setAttribute("popupStatus", "success");
    RequestDispatcher dispatcher = request.getRequestDispatcher(origem);
    dispatcher.forward(request, response);

%>



