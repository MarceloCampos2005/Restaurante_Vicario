<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    String mesa = request.getParameter("mesa");
    if (mesa == null) {
        response.sendRedirect("planta_restaurante.jsp");
        return;
    }

    int mesaId = Integer.parseInt(mesa);

    try {
        Class.forName("org.mariadb.jdbc.Driver");

        String url = "jdbc:mariadb://mysql-vicario.alwaysdata.net:3306/vicario_data";
        String user = "vicario";
        String password = "MarceloMoura123";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql_esta1 = "SELECT id_prato, quantidade, preco_venda FROM mesa_prato  WHERE id_mesa = ?";
            try (PreparedStatement stmt_esta1 = conn.prepareStatement(sql_esta1)) {
                stmt_esta1.setInt(1, mesaId);
                try (ResultSet rs_esta1 = stmt_esta1.executeQuery()) {
                    while (rs_esta1.next()) {
                        int id_prato = rs_esta1.getInt("id_prato");
                        double quantidade_esta_tot = rs_esta1.getDouble("quantidade");
                        double preco_venda = rs_esta1.getDouble("preco_venda");
                        String sql_esta3 = "SELECT nr_doses FROM prato_estatistica WHERE id_tipo_prato = ?";
                        try (PreparedStatement ps_esta3 = conn.prepareStatement(sql_esta3)) {
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
                            try (ResultSet rs_esta2 = ps_esta3.executeQuery()) {
                                if (rs_esta2.next()) {
                                    double quantidade_esta = rs_esta2.getDouble("nr_doses");
                                    quantidade_esta_tot += quantidade_esta;
                                }
                            }
                        }
                        String sql_esta2 = "UPDATE prato_estatistica SET nr_doses = ? WHERE id_tipo_prato = ?";
                        try (PreparedStatement ps_esta2 = conn.prepareStatement(sql_esta2)) {
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
                        }
                        double faturamento = 0;
                        String sql_esta4 = "SELECT faturamento FROM faturamento_mesa";
                        try (PreparedStatement ps_esta4 = conn.prepareStatement(sql_esta4)) {
                            ResultSet rs_esta4 = ps_esta4.executeQuery();
                            if (rs_esta4.next()) {
                                faturamento = rs_esta4.getDouble("faturamento");
                                faturamento += preco_venda;
                            }
                        }
                        String sql_esta5 = "UPDATE faturamento_mesa SET faturamento = ?";
                        try (PreparedStatement ps_esta5 = conn.prepareStatement(sql_esta5)) {
                            ps_esta5.setDouble(1, faturamento);
                            ps_esta5.executeUpdate();
                        }
                    }
                }
            }
            String sqlDelete = "DELETE FROM mesa_prato WHERE id_mesa = ?";
            try (PreparedStatement stmtDelete = conn.prepareStatement(sqlDelete)) {
                stmtDelete.setInt(1, mesaId);
                stmtDelete.executeUpdate();
            }

            // Depois atualizar o preço da mesa para 0
            String sqlUpdate = "UPDATE mesa SET preco_tot = 0 WHERE id_mesa = ?";
            try (PreparedStatement stmtUpdate = conn.prepareStatement(sqlUpdate)) {
                stmtUpdate.setInt(1, mesaId);
                stmtUpdate.executeUpdate();
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    String origem = request.getParameter("origem");
    if (origem == null || origem.isEmpty()) {
        origem = "index.jsp";
    }

    response.sendRedirect(origem);
%>
