/**
 * k-wk-jsBridge.d.ts
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

    /**
     * 获取照片
     * @param {number} type type: 0调起相机拍摄照片，type: 1调起相册选择照片
     * @param {boolean} allowsEditing 能否编辑
     * @param {(data) => void} callback 回调方法获取返回值
     */
    static choosePhoto(type: number, allowsEditing: boolean, callback?: (data: any) => void): void

    /**
     * 预览图片
     * @param {string} imageUrl 图片路径：可以是网络路径、可以是base64、可以是本地路径
     */
    static previewImage(imageUrl: string): void

    /**
     * 调起打电话
     * @param {string} phoneNumber 电话号码：手机、固话
     */
    static call(phoneNumber: string): void
}
