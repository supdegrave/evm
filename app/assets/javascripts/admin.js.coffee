# 
# get / set user data 
# 
AdminData = {
  SelectedUser: null
  UserData: {}
  Functions: null
  Roles: null
}

$.ajax {
  url: "/functions.json"
  success: (json) => initCollection "Function", json
  error: (xhr, status) => console.log xhr, status
}
$.ajax {
  url: "/roles.json"
  success: (json) => initCollection "Role", json
  error: (xhr, status) => console.log xhr, status
}

initCollection = (collectionName, json) -> AdminData[collectionName.concat('s')] = json

# 
# databind tables / lists 
# 
functions_table = rivets.bind $("#functions_table"), {data: AdminData}
roles_table = rivets.bind $("#roles_table"), {data: AdminData}
new_functions = rivets.bind $("#new-function"), {data: AdminData}
new_roles = rivets.bind $("#new-role"), {data: AdminData}

# 
# modal dialog select elements 
# 
selRole = $("#new-role")
selFunc = $("#new-function")


# 
# role select event handlers
# 
# ##### TODO ###############
# * move hard-coded ["admin", "Board Member"] to external js file to allow configuration
#   - js file should simply assign an array of strings to variable
#   - update selRole.change handler to set that variable to [] if null / undefined
selRole.change (evt) ->
  isNonFunctionRole = selRole.children().filter(":selected").text() in ["admin", "Board Member"]
  selFunc.prop("disabled", isNonFunctionRole) 
  selFunc.prop('selectedIndex', 0) if isNonFunctionRole


# 
# 'add role' button event handler
#
$("button#add-role").click (evt) -> 
  optRole = selRole.children().filter(":selected") 
  optFunc = selFunc.children().filter(":selected") 
  
  if optRole.val().length # do not allow blank role
    role = optRole.text()
    func = if optFunc.val().length then optFunc.val() else if selFunc.prop("disabled") then "" else null 
    
    unless func == null
      $.ajax({
        url: "/admin/add_role"
        type: "POST"
        dataType: "json"
        data: {
          user: {
            user_id: AdminData.SelectedUser
            function_id: func if func.length
            role_name: role
          }
        }
        success: (json) =>
          AdminData.UserData[AdminData.SelectedUser] = json
          showRoleList AdminData.SelectedUser
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
# cancel button event handler
# 
$("button#cancel-add-role").click -> resetModal()


# 
# reset modal selects, hide dialog
#
resetModalSelects = () ->   
  selRole.prop('selectedIndex', 0)
  selFunc.prop('selectedIndex', 0)
  selFunc.prop("disabled", false) 
   
resetModal = () -> 
  $('#myModal').foundation('reveal', 'close')


# 
# modal dialog closed 
# 
$(document).on 'closed', '[data-reveal]', () ->
  AdminData.SelectedUser = null
  resetModalSelects()
  $("div#modal-error").empty().hide()
  

# 
# insert new user, function, role into page 
# 
handleAjaxResponse = (model) -> 
  $("#new_" + model)
    .on "ajax:success", (e, data, status, xhr) -> 
      # console.log $(e.target).siblings('input').val
      form_row = $(e.target).parent()
      form_row.find('input').val(String.empty) 
      
      if ("user" == model)
        form_row.before(data.html)
        new_user_data = $(data.html).find("ul").data()
        AdminData.UserData[new_user_data.userId] = new_user_data.userRoles
        bindRoleEditEvents()
        $('#myModal').foundation({bindings: 'events'});
      else
        collectionName = e.target.id.slice(4,5).toUpperCase().concat(e.target.id.slice(5))
        initCollection collectionName, data
    .on 'ajax:error', (e, xhr, status, error) -> console.log e, xhr, status, error
  
handleAjaxResponse "user"
handleAjaxResponse "function"
handleAjaxResponse "role"


# 
# wire up mouseover / mouseout toggle of role edit link 
# and show modal dialog with roles for selected user
# 
bindRoleEditEvents = () ->
  $(".role-edit")
    .mouseenter( (evt) -> $(evt.target).children("span").show() )
    .mouseleave( (evt) -> $(evt.target).children("span").hide() )
    
  $(".role-edit span").click (evt) -> 
    target = $(evt.target).hide()
    AdminData.SelectedUser = target.next().data('user-id')
    showRoleList(AdminData.SelectedUser, true)
    $('#myModal').foundation('reveal', 'open')

bindRoleEditEvents()


# 
# show list of roles for given user 
# 
showRoleList = (userId, modal = false) -> 
  list = if modal then $("#myModal .modal-user-roles") else $("ul.user-roles[data-user-id='" + userId + "']") 
  listItems = []

  for role in AdminData.UserData[userId]
    listItems.push "<li>"
    listItems.push role["function"]
    listItems.push " " if role["function"]
    listItems.push role["role"]
    listItems.push " <span class='delete-role'>[delete]</span>" if modal
    listItems.push "</li>"

  list.empty().append(listItems.join("")) 


# 
# populate user roles on admin page
# 
$.each $("ul.user-roles"), (inx, val) ->
  list = $(val)
  userId = list.data('user-id')
  AdminData.UserData[userId] = list.data('user-roles')
  showRoleList userId
