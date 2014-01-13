# 
# get / set user data 
# 
AppData = {
  SelectedUser: null
  Functions: null
  Roles: null
  Role: (name) -> 
    for role in this.Roles 
      return role if name == role.name 
  Users: null
  User: (id) -> 
    for user in this.Users
      return user if id == user.id 
}

["Functions", "Roles", "Users"].forEach (app_class) -> 
  $.ajax {
    url: "/" + app_class.toLowerCase() + ".json"
    success: (json) => AppData[app_class] = json
    error: (xhr, status) => console.log xhr, status
  }


# 
# databind tables / lists 
# 
["#functions_table", "#roles_table", "#new-function", "#new-role", "#users_table"].forEach (elem) -> 
  rivets.bind $(elem), {data: AppData}


# 
# modal dialog select / list elements 
# 
selRole = $("#new-role")
selFunc = $("#new-function")
rolesList = $('ul.modal-user-roles')


# 
# role select onchange handler
# 
selRole.change () ->
  roleName = selRole.children(':selected').text()
  isFunctionRole = AppData.Role(roleName).is_functional
  selFunc.prop("disabled", !isFunctionRole) 
  selFunc.prop('selectedIndex', 0) unless isFunctionRole


# 
# 'add role' button onclick handler
#
$("button#add-role").click (evt) -> 
  optRole = selRole.children().filter(":selected") 
  optFunc = selFunc.children().filter(":selected") 
  
  if optRole.val().length # do not allow blank role
    role = optRole.text()
    func = if optFunc.text().length then optFunc.text() else if selFunc.prop("disabled") then "" else null 
        
    unless func == null
      $.ajax({
        url: "/admin/add_role"
        type: "POST"
        dataType: "json"
        data: {
          user: {
            user_id: AppData.SelectedUser
            function: func if func.length
            role: role
          }
        }
        success: (json) =>
          AppData.User(AppData.SelectedUser).functions_roles = json
          resetModal()
        error: (xhr, status) =>
          modalError = $("div#modal-error")
          modalError.append xhr.responseJSON["error"]     
          resetModalSelects()     
          modalError.show()            
      });
    else
      console.log "ERROR - no function selected" 


# 
# cancel button onclick handler
# 
$("button#cancel-add-role").click -> resetModal()


# 
# reset modal selects, hide dialog
#
resetModal = () -> $('#myModal').foundation('reveal', 'close')
resetModalSelects = () ->   
  selRole.prop('selectedIndex', 0)
  selFunc.prop('selectedIndex', 0)
  selFunc.prop("disabled", false) 


# 
# modal dialog closed 
# 
$(document).on 'closed', '[data-reveal]', () ->
  rolesList.empty()
  resetModalSelects()
  $("div#modal-error").empty().hide()
  

# 
# insert new user, function, role into page 
# 
["Users", "Functions", "Roles"].forEach (model) -> 
  $("#new_" + model.toLowerCase().slice(0,-1))
    .on "ajax:success", (e, data, status, xhr) -> 
      $(e.target).parent().find('input').val(String.empty)       
      if ("Users" == model)
        AppData.Users.push(data)
        $('#myModal').foundation({bindings: 'events'});
      else
        AppData[model] = data
    .on 'ajax:error', (e, xhr, status, error) -> console.log e, xhr, status, error


# 
# wire up mouseover / mouseout toggle of role edit link 
# and show modal dialog with roles for selected user
# 
$('#users_table').on 'DOMNodeInserted', (e) -> 
  elem = $(e.target).children(':last')

  elem
    .mouseenter( (evt) -> $(evt.target).children("span").show() )
    .mouseleave( (evt) -> $(evt.target).children("span").hide() )

  elem.children('span').click (evt) -> 
    target = $(evt.target).hide()
    AppData.SelectedUser = parseInt(target.find('span').text())
    AppData.User(AppData.SelectedUser).functions_roles.forEach (f_r) ->
      content = ["<li>", (f_r.function || ""), f_r.role, "</li>"]
      rolesList.append(content.join(" "))
    $('#myModal').foundation('reveal', 'open')
