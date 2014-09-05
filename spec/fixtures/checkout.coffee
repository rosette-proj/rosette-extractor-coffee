# taken from forrager source code

Forrager.Pages ||= {}

class Forrager.Pages.OrderCheckoutPage
  constructor: (options) ->
    @grand_total = options.grand_total

  update_summary: ->
    summary = ""
    tip_amount = parseFloat($("#hid-tip-amount").val().replace(/[^\d|\.]+/, "").trim()) || 0.0

    if tip_amount > 0
      tip_type = if $("#tip-percentage-radio").attr("checked") then "percentage" else "cash"

      if tip_amount > 100 && tip_type == "percentage"
        tip_amount = 100

      if tip_type == "percentage"
        tip =  Math.round(((tip_amount / 100.0) * this.grand_total) * 100.0) / 100.0
        tip_amount_text = tip_amount + "%"
        summary = _("A %{tip_amount} tip of $%{tip_calc} will be added to your order of $%{total} for a total of $%{grand_total}.")
      else
        tip = tip_amount
        tip_amount_text = "$" + tip_amount
        summary = _("A tip of $%{tip_calc} will be added to your order of $%{total} for a total of $%{grand_total}.")

      final_amount = Math.round((this.grand_total + tip) * 100.0) / 100.0
      summary = summary.replace("%{tip_amount}", tip_amount_text)
      summary = summary.replace("%{tip_calc}", tip.toFixed(2))
      summary = summary.replace("%{total}", this.grand_total.toFixed(2))
      summary = summary.replace("%{grand_total}", final_amount.toFixed(2))

    $("#tip-summary").text(summary)

  selected_percentage: ->
    elem = $("li.active", $(".pag-percent"))
    if elem.length == 0 then $("#tip-custom-percent").val() else elem.text()

  selected_cash_amount: ->
    elem = $("li.active", $(".pag-cash"))
    if elem.length == 0 then $("#tip-custom-cash").val() else elem.text()

$(document).ready ->
  current_page = Forrager.current_page = new Forrager.Pages.OrderCheckoutPage({grand_total: $("#page-data").data("grand-total")})
  current_page.update_summary()

  current_page.tip_modal = new Forrager.PopForm($("#change-tip-modal"))

  $("li", $(".pag-percent")).click ->
    $("li", $(".pag-percent")).removeClass("active")
    $(this).addClass("active")
    $("#hid-tip-amount").val($(this).text())
    current_page.update_summary()

  $("li", $(".pag-cash")).click ->
    $("li", $(".pag-cash")).removeClass("active")
    $(this).addClass("active")
    $("#hid-tip-amount").val($(this).text())
    current_page.update_summary()

  $("#tip-percentage-radio").parent().click ->
    $(".pag-percent").slideDown()
    $(".pag-cash").slideUp()
    $("#hid_tip-amount").val(current_page.selected_percentage())
    current_page.update_summary()

  $("#tip-cash-radio").parent().click ->
    $(".pag-cash").slideDown('slow')
    $(".pag-percent").slideUp('slow')
    $("#hid-tip-amount").val(current_page.selected_cash_amount())
    current_page.update_summary()

  $("#tip-custom-percent, #tip-custom-cash").keyup ->
    $("li", $(".pag-cash")).removeClass("active")
    $("li", $(".pag-percent")).removeClass("active")
    $("#hid-tip-amount").val($(this).val())
    current_page.update_summary()

  $("#add-tip, .btn-tip-change").click ->
    current_page.tip_modal.show()

  $("#no-thanks").click ->
    $("#tip-consider").hide()
