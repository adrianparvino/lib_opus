#include <erl_nif.h>

#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <unistd.h>
#include <opus/opus.h>

#define FRAME_SIZE 960
#define BUFFER_SIZE FRAME_SIZE*2*2
#define MAX_PACKET_SIZE 1276

static ErlNifResourceType *OPUS_ENCODER;

static ERL_NIF_TERM create_encoder(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  OpusEncoder *encoder;
  ERL_NIF_TERM encoder_term;

  encoder = enif_alloc_resource(OPUS_ENCODER, opus_encoder_get_size(2));

  opus_encoder_init(encoder, 48000, 2, OPUS_APPLICATION_AUDIO);
  encoder_term = enif_make_resource(env, encoder);

  enif_release_resource(encoder);

  return encoder_term;
}

static ERL_NIF_TERM from_pcm(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  OpusEncoder *encoder;
  ErlNifBinary pcm;
  opus_int16 *buffer;
  ssize_t opus_size;
  ErlNifBinary opus_binary;

  enif_get_resource(env, argv[0], OPUS_ENCODER, (void **) &encoder);
  enif_inspect_binary(env, argv[1], &pcm);

  if (pcm.size < BUFFER_SIZE) {
    buffer = (opus_int16 *) enif_alloc(BUFFER_SIZE);
    memcpy(buffer, pcm.data, pcm.size);
    memset(buffer, 0, BUFFER_SIZE - pcm.size);
  } else {
    buffer = (opus_int16 *) pcm.data;
  }
  enif_alloc_binary(MAX_PACKET_SIZE, &opus_binary);

  opus_size = opus_encode(encoder, buffer, FRAME_SIZE, opus_binary.data, MAX_PACKET_SIZE);
  enif_realloc_binary(&opus_binary, opus_size);

  if (buffer != (opus_int16 *) pcm.data) {
    enif_free(buffer);
  }

  return enif_make_binary(env, &opus_binary);
}

static ErlNifFunc nif_funcs[] =
{
  {"create_encoder", 0, create_encoder},
  {"from_pcm", 2, from_pcm},
};

static int nif_load(ErlNifEnv * env, void ** priv_data, ERL_NIF_TERM load_info) {
  OPUS_ENCODER = enif_open_resource_type(env, NULL, "your_nif", NULL,
                                         ERL_NIF_RT_CREATE, NULL);

  return 0;
}

ERL_NIF_INIT(Elixir.LibOpus,nif_funcs,nif_load,NULL,NULL,NULL)
