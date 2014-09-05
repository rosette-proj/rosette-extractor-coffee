# taken from forrager source code

Forrager.Pages ||= {}

$(document).ready ->
  Forrager.Pages.SalesPage = {
    hook_up_status_button_events: ->
      $(".mark-btn").click (e) ->
        $(".spinner", $(this)).show()

      # prevent links from opening the expandos (buttons ok)
      $("a").click (e) ->
        if $(this).attr("class").indexOf("btn") < 0
          e.stopPropagation()
  }

  current_page = Forrager.current_page = Forrager.Pages.SalesPage

  $(".line-item-image").each( (index, image) ->
    glance = $(".line-item-glance", $(this).parent())

    $(image).popover(
      html: true,
      trigger: "hover",
      title: _("At a Glance"),
      content: ->
        glance.html()
    )
  )

  current_page.hook_up_status_button_events()
