defmodule LibOpus do
  @frame_bytes 3840

  @on_load :load_nifs
  use GenServer

  def load_nifs do
    path = Application.app_dir(:lib_opus, ["priv", "opus-nif"])
    :erlang.load_nif(String.to_charlist(path), 0)
  end

  def start(args) do
    GenServer.start(__MODULE__, args)
  end

  def init(file) do
    {:ok, %{file: file, residual: "", packet: nil, encoder: create_encoder()}, {:continue, nil}}
  end

  def handle_call(:get_packet, from,
    %{ file: file,
       residual: residual,
       packet: packet
    } = state) do

    GenServer.reply(from, packet)

    {:reply, packet, state, {:continue, nil}}
  end

  def handle_continue(_continue, state) do
    {frame, residual} = extract_pcm_frame(state.file, state.residual)
    packet = from_pcm(state.encoder, frame)

    {:noreply, %{state | packet: packet, residual: residual}}
  end

  def get_packet(pid) do
    GenServer.call(pid, :get_packet)
  end

  def extract_pcm_frame(stream, <<frame::binary-size(@frame_bytes)>> <> residual) do
    {frame, residual}
  end
  def extract_pcm_frame(stream, residual) do
    case Enum.take(stream, 1) do
      [string] -> extract_pcm_frame(stream, residual <> string)
      [] -> {residual, ""}
    end
  end

  def create_encoder() do
    raise "NIF Nostrum.OpusEncode.create_encoder/0 not loaded"
  end

  def from_pcm(_a, _b) do
    raise "NIF Nostrum.OpusEncode.from_pcm/2 not loaded"
  end
end
