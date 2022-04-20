defmodule ProcessRing do

  def start_process_ring(msg, process_count) do
    IO.puts("Starting process ring from #{inspect self()}")
    
    first_pid = self()
    pid = spawn(fn -> next_process(process_count, first_pid) end)
    send(pid, msg)
    receive do
      msg -> IO.inspect{msg, self()} 
    end
  end

  def next_process(1, first_pid) do
    receive do
      msg ->
        IO.inspect({msg, self(), 1})
        send(first_pid, msg)
    end
  end

  def next_process(process_count, first_pid) do
    receive do
      msg -> 
        IO.inspect({msg, self(), process_count})
        pid = spawn(fn -> next_process(process_count - 1, first_pid) end)
        send(pid, msg)
    end
  end
  
end
