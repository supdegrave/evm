# console.log $("button#add-role")

$("button#add-role").click( (evt) => 
  selectedFunction = $("#new-function option:selected")
  selectedRole = $("#new-role option:selected")
  
  # do not allow blank role
  unless String.empty == selectedRole.val()
    role = selectedRole.text()
    
    # if role is admin or Board Member, allow blank func
    if role in ["admin", "Board Member"] 
      $("#new-function").val("")
      func = ""
    else 
      func = if selectedFunction.val() != "" then selectedFunction.val() else null
      
    # TODO: don't allow func without role 
      
    unless func == null 
      user_id = $("#myModal .modal-user-roles").attr("data-user-id")
      
      $.ajax({
        url: "/admin/add_role",
        data: {
          user: {
            user_id: user_id
            function_id: func unless func == ""
            role_name: role
          }
        },
        type: "POST",
        dataType : "json",
        success: ( json ) =>
          $('#myModal').foundation('reveal', 'close')
          roles_list = $("ul.user-roles[data-user-id='" + user_id + "']")
          roles_list.attr("data-user-roles", JSON.stringify(json))
          
          appendRoles(roles_list)
        ,
        error: ( xhr, status ) =>
          console.log "Sorry, there was a problem!" 
      });
    else
      console.log "ERROR - no function selected" 
    
  # do not allow double-assignment (maybe this should be a DB unique constraint)
  # reset form values 
)

# 
# insert new user, function, role into page 
# 
handleAjaxResponse = (model) => 
  modelForm = $("#new_" + model)

  modelForm.on("ajax:success", (e, data, status, xhr)-> 
    $("[id^='" + model + "_']").val(String.empty) 
    $("#new_" + model).parent().before(data.html) 
  )

  modelForm.on('ajax:error', (e, xhr, status, error)-> 
    console.log e
    console.log xhr
    console.log status
    console.log error
  )
  
handleAjaxResponse "user"
handleAjaxResponse "function"
handleAjaxResponse "role"

# 
# wire up mouseover / mouseout toggle of role edit link 
# 
$(".role-edit")
  .mouseenter( (evt) => $(evt.target).children("span").show() )
  .mouseleave( (evt) => $(evt.target).children("span").hide() );

appendRoles = (list, roles = null) => 
  list.empty()
  if roles == null
    roles = list.attr('data-user-roles')
  else
    showDelete = true

  roles = JSON.parse(roles)
  
  for role in roles
    # role = JSON.parse(role)
    listItem = ["<li>"]
    listItem.push (role["function"] || "")
    listItem.push " " if role["function"]
    listItem.push role["role"]
    listItem.push " <span class='delete-role'>[delete]</span>" if showDelete
    listItem.push "</li>"
    list.append(listItem.join("")) 

# 
# show modal dialog with roles for selected user
#  
$(".role-edit span").click (evt) => 
  target = $(evt.target).hide()
  list = target.next()
  modalList = $("#myModal .modal-user-roles")
  modalList.attr('data-user-id', list.attr('data-user-id'))
  
  appendRoles(modalList, list.attr('data-user-roles'))
  # appendRoles(modalList, JSON.parse(list.attr('data-user-roles')))

# 
# populate user roles on admin page
# 
$.each($("ul.user-roles"), (inx, val) =>
  list = $(val)
  userId = list.attr('data-user-id')  
  appendRoles(list)
);


# ##### SQL TO CLEAR ROLES #####
# delete from roles where id > 106; delete from users_roles where user_id != 2; delete from users_roles where role_id != 56; select * from roles; select * from users_roles; 
