open Players
open State

type t =
  | Call
  | Check
  | Fold
  | Raise of int

let action player state options =
  print_endline "===-----------------------------------===";
  Printf.printf "             Current Pot: %i           \n" (get_pot state);
  Printf.printf "             Current Bet: %i           \n"
    (get_current_bet state);
  print_endline "===-----------------------------------===";

  Printf.printf "\nIt is %s's turn to go!\n" (get_name player);
  let rec prompt_action () =
    print_endline ("Available actions: " ^ String.concat ", " options);
    print_endline "Enter your action:";
    let input = read_line () in
    match input with
    | "call" when List.mem "call" options -> Call
    | "check"
      when List.mem "check" options
           && get_contributions player = get_current_bet state -> Check
    | "check" ->
        print_endline
          "You can only check if your contribution matches the current pot.";
        prompt_action ()
    | "fold" when List.mem "fold" options -> Fold
    | "raise" when List.mem "raise" options -> begin
        print_endline "Enter the amount to raise:";
        try
          let amount = int_of_string (read_line ()) in
          if amount > 0 then Raise amount
          else begin
            print_endline "Player should not be raising by a non-positive value";
            prompt_action ()
          end
        with _ ->
          print_endline "Invalid argument. Please enter a valid number.\n";
          prompt_action ()
      end
    | _ ->
        print_endline "Invalid action. Please try again.\n";
        prompt_action ()
  in
  prompt_action ()
