module ApplicationHelper

  def display_date(dt)
    dt.strftime("%m/%d/%Y %l:%M%P")
  end

  def us_states
      [
        'Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','District of Columbia',
        'Florida','Georgia', 'Hawaii', 'Idaho', 'Illinois','Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine',
        'Maryland', 'Massachusetts','Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 
        'New Hampshire','New Jersey', 'New Mexico', 'New York', 'North Carolina','North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 
        'Pennsylvania', 'Puerto Rico', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 
        'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
      ]
  end

  def path_value(object, object_param)
      if object_param.nil?
        if object
          return object.id 
        else
          return nil
        end
      else
        object_param
      end
  end

  def upcase_first(string)
    words = string.split

    words.each_with_index do |element, index|
      words[index] = element.first.upcase + element[1..-1]
    end
    words.join(" ")
  end


end
