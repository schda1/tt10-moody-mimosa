#ifndef TIMER_MOCK_H
#define TIMER_MOCK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>

typedef uint16_t TIM_HandleTypeDef;

/**
 * @brief Start a timer
 * 
 * @param htim Timer handle
 */
void timer_start(TIM_HandleTypeDef* htim);

/**
 * @brief Stop a timer
 * 
 * @param htim Timer handle
 */
void timer_stop(TIM_HandleTypeDef* htim);

/**
 * @brief Get the mocked timer
 * 
 * @return mocked timer
 */
bool timer_is_running(TIM_HandleTypeDef* htim);

#ifdef __cplusplus
}
#endif

#endif