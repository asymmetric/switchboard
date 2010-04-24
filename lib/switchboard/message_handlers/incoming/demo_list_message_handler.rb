require 'switchboard/message_handlers/incoming_message_handler.rb'
require 'twilio/twilio_sender'

module Switchboard::MessageHandlers::Incoming
    class DemoListMessageHandler < Switchboard::MessageHandlers::IncomingMessageHandler
        def handle_messages!()
            ## should be  outgoing_states.each |state,conditions| do 
            handled_state = MessageState.find_by_name('handled')
            messages_to_handle.each do |message|
                tokens = message.body.split(/ /)
                list_name = tokens[0].upcase
                list = List.find_or_create_by_name(list_name)
                 
                if (tokens.length == 1)
                    num = PhoneNumber.create!(:number => message.from )
                    list.add_phone_number(num)
                    create_outgoing_message( message.from, "You have joined the text message list called '" + tokens[0] + "'!" )
                end
            
                if (tokens.length > 1) 
                    list.phone_numbers.each do |phone_number|
                        body = '[' + list_name + '] ' + tokens[1..-1].join(' ')
                        create_outgoing_message(phone_number.number, body)
                    end
                end 
                handled_state.messages.push(message)
                handled_state.save
            end
        end


        def create_outgoing_message(to, body)
            message = Message.new
            message.to = to
            message.body = body

            message_state = MessageState.find_by_name("outgoing")
            message_state.messages.push(message)
            message_state.save! 
        end
    end
end