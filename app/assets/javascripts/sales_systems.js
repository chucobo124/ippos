function keyFunction() {
  if (event.keyCode==27) {
    alert("Esc 的內建功能已被取消！");
    return false;
  } else if (event.keyCode==8) {
    alert("Backspace 的內建功能已被取消！");
    return false;
  } else if (event.keyCode==9) {
    alert("Tab 的內建功能已被取消！");
    return false;
  } else if (event.keyCode==68) {
    var delete_button = document.getElementById('product_no');
    delete_button.style.backgroundColor = "red";
    var method = document.getElementById("new_product").getAttribute("action");
    method = "/sales_systems/del_cart";
    delete_button.style.backgroundColor = "rgb(255, 236, 236)";
    alert(method);
  }
}
document.onkeydown = keyFunction;