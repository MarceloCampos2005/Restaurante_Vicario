function selecionarPedido(id_pedido) {
  // Agora, envie o formulário manualmente
  document.getElementById('PedidoSelecionado').value = id_pedido;
  document.getElementById("formRetirarPedido").submit();
}