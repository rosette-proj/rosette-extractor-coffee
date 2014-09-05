# taken from forrager source code

Forrager.Product ||= {}

class Forrager.Product.FulfillmentSentence
  @sentences = {
    "delivery": {
      "none": -> _("You don't offer delivery."),
      "hours": [
        -> _("You deliver between %{start_time} and %{end_time} every day."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1}."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1} and %{day2}."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1}, %{day2}, and %{day3}."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, and %{day4}."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, %{day4}, and %{day5}."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, and %{day6}."),
        -> _("You deliver between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, %{day6}, and %{day7}.")
      ],
      "days": [
        -> _("You deliver all day every day."),
        -> _("You deliver all day on %{day1}."),
        -> _("You deliver all day on %{day1} and %{day2}."),
        -> _("You deliver all day on %{day1}, %{day2}, and %{day3}."),
        -> _("You deliver all day on %{day1}, %{day2}, %{day3}, and %{day4}."),
        -> _("You deliver all day on %{day1}, %{day2}, %{day3}, %{day4}, and %{day5}."),
        -> _("You deliver all day on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, and %{day6}."),
        -> _("You deliver all day on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, %{day6}, and %{day7}.")
      ]
    },
    "pickup": {
      "none": -> _("You don't offer pickup."),
      "hours": [
        -> _("You offer pickup between %{start_time} and %{end_time} every day."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1}."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1} and %{day2}."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1}, %{day2}, and %{day3}."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, and %{day4}."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, %{day4}, and %{day5}."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, and %{day6}."),
        -> _("You offer pickup between %{start_time} and %{end_time} on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, %{day6}, and %{day7}.")
      ],
      "days": [
        -> _("You offer pickup all day every day."),
        -> _("You offer pickup all day on %{day1}."),
        -> _("You offer pickup all day on %{day1} and %{day2}."),
        -> _("You offer pickup all day on %{day1}, %{day2}, and %{day3}."),
        -> _("You offer pickup all day on %{day1}, %{day2}, %{day3}, and %{day4}."),
        -> _("You offer pickup all day on %{day1}, %{day2}, %{day3}, %{day4}, and %{day5}."),
        -> _("You offer pickup all day on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, and %{day6}."),
        -> _("You offer pickup all day on %{day1}, %{day2}, %{day3}, %{day4}, %{day5}, %{day6}, and %{day7}.")
      ]
    }
  }

  @generate_shipping_sentence: (options = {}) ->
    key = index = result = null
    sentence_pool = @sentences[options.type]

    if options.hour_start == ""
      key = "days"
    else
      if options.hour_end != ""
        key = "hours"
      else
        key = "days"

    if (options.weekdays.length > 0) && (options.weekdays.length < 7)
      index = options.weekdays.length
    else if options.weekdays.length == 7
      index = 0
    else
      key = "none"

    if key?
      result = sentence_pool[key]
    
      if index?
        result = result[index]();
      else
        result = result()

    if result?
      for index, val of options.weekdays
        result = result.replace("%{day" + (parseInt(index) + 1) + "}", val)

      result.replace("%{start_time}", options.hour_start).replace("%{end_time}", options.hour_end)
    else
      ""
