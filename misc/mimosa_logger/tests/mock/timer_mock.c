#include <timer_mock.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>

#define MAX_MOCKED_TIMERS (10)

struct mocked_timer {
    TIM_HandleTypeDef* htim;
    bool running;
};

static struct mocked_timer timers[MAX_MOCKED_TIMERS];
static uint8_t n_mocked_timers = 0;

static struct mocked_timer* check_if_found_or_attach(TIM_HandleTypeDef* htim)
{
    /* Check if found */
    for (uint8_t i = 0; i < n_mocked_timers; i++) {
        if (timers[i].htim == htim) {
            return &timers[i];
        }
    }

    /* Attach */
    if (n_mocked_timers < MAX_MOCKED_TIMERS) {
        timers[n_mocked_timers].htim = htim;
        timers[n_mocked_timers].running = false;
        n_mocked_timers++;
        return &timers[n_mocked_timers - 1];
    }

    return NULL;
}

void timer_start(TIM_HandleTypeDef* htim)
{
    struct mocked_timer* timer = check_if_found_or_attach(htim);
    timer->running = true;
}

void timer_stop(TIM_HandleTypeDef* htim)
{
    struct mocked_timer* timer = check_if_found_or_attach(htim);
    timer->running = false;
}

bool timer_is_running(TIM_HandleTypeDef* htim)
{
    struct mocked_timer* timer = check_if_found_or_attach(htim);
    return timer->running;
}