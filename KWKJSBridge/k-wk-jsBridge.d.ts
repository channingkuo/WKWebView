/**
 *
 */
export declare class KWKJSB {

    /**
     * 测试方法
     * @param callback 回调方法获取返回值
     */
    static test(callback?: (data: any) => void): void

    /**
     * 打开App的设置页面
     * @param mode 设置页面打开方式，0: modal、1: NavigationController push，默认为0
     */
    static openSettings(mode: number): void

    /**
     * 模拟浏览器刷新当前页
     */
    static reload(): void

    /**
     * 模拟浏览器后退
     */
    static goBack(): void

    /**
     * 模拟浏览器前进
     */
    static goForward(): void

    /**
     * 获取定位信息
     * @param {number} precision 定位精度，默认100m
     * @param {(data) => void} callback 回调方法获取返回值
     */
    static location(precision: number, callback?: (data: any) => void): void
}
