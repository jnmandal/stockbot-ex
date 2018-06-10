defmodule Stockbot.Telegram.PollerTest do
  use ExUnit.Case

  alias Stockbot.Telegram.Poller

  describe "Poller.enqueue_message/1" do

    test "returns message id" do
      id = 123
      expected_id = Poller.enqueue_message(%{update_id: 123})
      assert expected_id == id
    end

  end

  describe "Poller.handle_updates/1" do

    test "returns nil for empty list" do
      updates = []
      assert nil == Poller.handle_updates({:ok, updates})
    end

    test "returns offset for list" do
      updates = [%{update_id: 123}, %{update_id: 124}]
      assert 125 == Poller.handle_updates({:ok, updates})
    end
  end
end
