// active nav item
window.addEventListener("load", function(event) {
  var dash = document.getElementsByClassName('dash')[0];
  var user = document.getElementsByClassName('user')[0];
  var post = document.getElementsByClassName('post')[0];

  if(window.location.pathname == '/dashboard') {
    dash.style.backgroundColor = 'blue';
 } else if (window.location.pathname == "/users/<%= session['user'] %>") {
    user.style.backgroundColor = 'blue';
 } else if (window.location.pathname == '/posts/create') {
    post.style.backgroundColor = 'blue';
}});
