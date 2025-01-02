/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "App.hpp"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
// UART_HandleTypeDef hlpuart1;

SPI_HandleTypeDef hspi2;

TIM_HandleTypeDef htim2;
TIM_HandleTypeDef htim3;

/* USER CODE BEGIN PV */
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_LPUART1_UART_Init(void);
static void MX_TIM2_Init(void);
static void MX_TIM3_Init(void);
static void MX_SPI2_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  // MX_LPUART1_UART_Init();
  // MX_TIM2_Init();
  // MX_TIM3_Init();
  // MX_SPI2_Init();
  /* USER CODE BEGIN 2 */
  // HAL_TIM_Base_Start_IT(&htim2);  
  // HAL_TIM_Base_Start_IT(&htim3);
  app_init();
  app_run();
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  HAL_PWREx_ControlVoltageScaling(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLM = RCC_PLLM_DIV1;
  RCC_OscInitStruct.PLL.PLLN = 10;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = RCC_PLLQ_DIV2;
  RCC_OscInitStruct.PLL.PLLR = RCC_PLLR_DIV2;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV1;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief LPUART1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_LPUART1_UART_Init(void)
{

  // /* USER CODE BEGIN LPUART1_Init 0 */

  // /* USER CODE END LPUART1_Init 0 */

  // /* USER CODE BEGIN LPUART1_Init 1 */

  // /* USER CODE END LPUART1_Init 1 */
  // hlpuart1.Instance = LPUART1;
  // hlpuart1.Init.BaudRate = 115200;
  // hlpuart1.Init.WordLength = UART_WORDLENGTH_8B;
  // hlpuart1.Init.StopBits = UART_STOPBITS_1;
  // hlpuart1.Init.Parity = UART_PARITY_NONE;
  // hlpuart1.Init.Mode = UART_MODE_TX_RX;
  // hlpuart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  // hlpuart1.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
  // hlpuart1.Init.ClockPrescaler = UART_PRESCALER_DIV1;
  // hlpuart1.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
  // if (HAL_UART_Init(&hlpuart1) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // if (HAL_UARTEx_SetTxFifoThreshold(&hlpuart1, UART_TXFIFO_THRESHOLD_1_8) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // if (HAL_UARTEx_SetRxFifoThreshold(&hlpuart1, UART_RXFIFO_THRESHOLD_1_8) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // if (HAL_UARTEx_DisableFifoMode(&hlpuart1) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // /* USER CODE BEGIN LPUART1_Init 2 */

  // /* USER CODE END LPUART1_Init 2 */

}

/**
  * @brief SPI2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_SPI2_Init(void)
{

  // /* USER CODE BEGIN SPI2_Init 0 */

  // /* USER CODE END SPI2_Init 0 */

  // /* USER CODE BEGIN SPI2_Init 1 */

  // /* USER CODE END SPI2_Init 1 */
  // /* SPI2 parameter configuration*/
  // hspi2.Instance = SPI2;
  // hspi2.Init.Mode = SPI_MODE_MASTER;
  // hspi2.Init.Direction = SPI_DIRECTION_2LINES;
  // hspi2.Init.DataSize = SPI_DATASIZE_8BIT;
  // hspi2.Init.CLKPolarity = SPI_POLARITY_LOW;
  // hspi2.Init.CLKPhase = SPI_PHASE_1EDGE;
  // hspi2.Init.NSS = SPI_NSS_SOFT;
  // hspi2.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_128;
  // hspi2.Init.FirstBit = SPI_FIRSTBIT_MSB;
  // hspi2.Init.TIMode = SPI_TIMODE_DISABLE;
  // hspi2.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
  // hspi2.Init.CRCPolynomial = 7;
  // hspi2.Init.CRCLength = SPI_CRC_LENGTH_DATASIZE;
  // hspi2.Init.NSSPMode = SPI_NSS_PULSE_ENABLE;
  // if (HAL_SPI_Init(&hspi2) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // /* USER CODE BEGIN SPI2_Init 2 */

  // /* USER CODE END SPI2_Init 2 */

}

/**
  * @brief TIM2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM2_Init(void)
{

  // /* USER CODE BEGIN TIM2_Init 0 */

  // /* USER CODE END TIM2_Init 0 */

  // TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  // TIM_MasterConfigTypeDef sMasterConfig = {0};

  // /* USER CODE BEGIN TIM2_Init 1 */

  // /* USER CODE END TIM2_Init 1 */
  // htim2.Instance = TIM2;
  // htim2.Init.Prescaler = 81;
  // htim2.Init.CounterMode = TIM_COUNTERMODE_UP;
  // htim2.Init.Period = 10000;
  // htim2.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  // htim2.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_ENABLE;
  // if (HAL_TIM_Base_Init(&htim2) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  // if (HAL_TIM_ConfigClockSource(&htim2, &sClockSourceConfig) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  // sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  // if (HAL_TIMEx_MasterConfigSynchronization(&htim2, &sMasterConfig) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // /* USER CODE BEGIN TIM2_Init 2 */

  // /* USER CODE END TIM2_Init 2 */

}

/**
  * @brief TIM3 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM3_Init(void)
{

  // /* USER CODE BEGIN TIM3_Init 0 */

  // /* USER CODE END TIM3_Init 0 */

  // TIM_ClockConfigTypeDef sClockSourceConfig = {0};
  // TIM_MasterConfigTypeDef sMasterConfig = {0};

  // /* USER CODE BEGIN TIM3_Init 1 */

  // /* USER CODE END TIM3_Init 1 */
  // htim3.Instance = TIM3;
  // htim3.Init.Prescaler = 0;
  // htim3.Init.CounterMode = TIM_COUNTERMODE_UP;
  // htim3.Init.Period = 801;
  // htim3.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  // htim3.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_ENABLE;
  // if (HAL_TIM_Base_Init(&htim3) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
  // if (HAL_TIM_ConfigClockSource(&htim3, &sClockSourceConfig) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
  // sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
  // if (HAL_TIMEx_MasterConfigSynchronization(&htim3, &sMasterConfig) != HAL_OK)
  // {
  //   Error_Handler();
  // }
  // /* USER CODE BEGIN TIM3_Init 2 */

  // /* USER CODE END TIM3_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, clk_Pin|rst_n_Pin|pwm_0_Pin|pwm_1_Pin
                          |pwm_2_Pin|pwm_3_Pin|pwm_4_Pin|pwm_5_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_12, GPIO_PIN_RESET);

  /*Configure GPIO pins : PC13 PC14 PC15 PC0
                           PC1 PC2 PC3 PC4
                           PC5 PC6 PC7 PC8
                           PC9 PC10 PC11 PC12 */
  GPIO_InitStruct.Pin = GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15|GPIO_PIN_0
                          |GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_3|GPIO_PIN_4
                          |GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7|GPIO_PIN_8
                          |GPIO_PIN_9|GPIO_PIN_10|GPIO_PIN_11|GPIO_PIN_12;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

  /*Configure GPIO pins : clk_Pin rst_n_Pin pwm_0_Pin pwm_1_Pin
                           pwm_2_Pin pwm_3_Pin pwm_4_Pin pwm_5_Pin */
  GPIO_InitStruct.Pin = clk_Pin|rst_n_Pin|pwm_0_Pin|pwm_1_Pin
                          |pwm_2_Pin|pwm_3_Pin|pwm_4_Pin|pwm_5_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

  /*Configure GPIO pins : PB0 PB1 PB2 PB10
                           PB3 PB4 PB5 PB6
                           PB7 PB9 */
  GPIO_InitStruct.Pin = GPIO_PIN_0|GPIO_PIN_1|GPIO_PIN_2|GPIO_PIN_10
                          |GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6
                          |GPIO_PIN_7|GPIO_PIN_9;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pin : PB12 */
  GPIO_InitStruct.Pin = GPIO_PIN_12;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
