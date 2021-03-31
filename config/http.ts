/*
 * @Descripttion: axios 配置项
 * @Author: KuuBee
 * @Date: 2021-03-31 10:53:19
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-03-31 10:53:19
 */

import axios from "axios";

export const httpClient = axios.create({
  baseURL: `${process.env.basePath}/api`,
  timeout: 10000
});
