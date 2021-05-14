/*
 * @Descripttion: app FAB
 * @Author: KuuBee
 * @Date: 2021-05-14 14:20:18
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-05-14 15:18:04
 */
import { NextComponentType } from "next";
import Zoom from "@material-ui/core/Zoom";
import Fab from "@material-ui/core/Fab";
import UpIcon from "@material-ui/icons/KeyboardArrowUp";
import { TransitionProps } from "@material-ui/core/transitions";
import styles from "../styles/widget/AppFAB.module.scss";
import { useEffect, useState } from "react";
import { ToggleButtonGroup } from "@material-ui/lab";

export const AppFAB: NextComponentType = (props) => {
  let screenHeight: number = NaN;
  const transitionDuration: TransitionProps["timeout"] = {
    enter: 200,
    exit: 200
  };
  const [isShow, setIsShow] = useState(false);

  useEffect(() => {
    if (Number.isNaN(screenHeight)) {
      screenHeight = screen.height;
    }
    window.addEventListener("scroll", () => {
      const shouldShow = scrollY > screenHeight + 200;
      setIsShow(shouldShow);
    });
  }, []);
  function toTop() {
    window.scrollTo({
      behavior: "smooth",
      top: 0
    });
  }

  const buildFAB = (
    <Zoom
      in={isShow}
      timeout={transitionDuration}
      style={{
        transitionDelay: "200ms"
      }}
      unmountOnExit
    >
      <Fab className={styles.fab} color="primary" onClick={toTop}>
        <UpIcon />
      </Fab>
    </Zoom>
  );

  return buildFAB;
};
