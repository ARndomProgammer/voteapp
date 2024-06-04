import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

actor VoteApp {

  // Define the voting options
  type Option = {
    name : Text;
    var votes : Nat;
  };
  // Initialize the voting options
  var options : [Option] = [
    { name = "Option A"; var votes = 0; },
    { name = "Option B"; var votes = 0; },
    { name = "Option C"; var votes = 0; },
  ];

  // Define the user's vote
  type Vote = {
    user : Text;
    option : Nat;
  };

  // Initialize the votes cast
  var votes : [Vote] = [];

  // Function to cast a vote
  public func castVote(vote : Vote) : async () {
    // Check if the user has already voted
    for (v in votes.vals()) {
      if (v.user == vote.user) {
        Debug.print("User has already voted");
        return;
      }
    };

    // Update the vote count
    options[vote.option].votes += 1;
    votes := Array.append<Vote>(votes, [vote]);

    Debug.print("Vote cast successfully");
  };

  // Function to get the current vote count
  public func getVoteCount() : async [Nat] {
    let counts = Array.map<Option, Nat>(options, func (o : Option) { o.votes });
    return counts;
  };

  // Function to get the winner
  public func getWinner() : async Text {
    let maxVotes = Array.foldLeft<Option, Nat>(options, 0, func (x : Nat, o : Option) { Nat.max(x, o.votes) });
    let winner = Array.find<Option>(options, func (o : Option) { o.votes == maxVotes });
    switch winner {
      case (?winner) { winner.name };
      case null { "No winner" };
    };
  };
}